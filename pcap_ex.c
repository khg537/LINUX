#include <stdio.h>
#include <string.h>

#include <netinet/in.h>
#include <arpa/inet.h>

#include <pcap.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>

#pragma pack(push, 1)
typedef struct ether_header{
	unsigned char dst[6];
	unsigned char src[6];
	unsigned short type;
} ether_header;
#pragma pack(pop)

void packet_handler(u_char *param,
  const struct pcap_pkthdr *header, const u_char *pkt_data); 

int main(int argc, char **argv) {
    pcap_t *adhandle;
    char errbuf[PCAP_ERRBUF_SIZE];
    pcap_if_t *alldevs;
    pcap_if_t *d;
    struct pcap_addr *a;
    int i = 0;
    int no;

    if (pcap_findalldevs(&alldevs, errbuf) < 0) {
        printf("pcap_findalldevs error\n");
        return 1;
    }

    for (d=alldevs; d; d=d->next) {
        printf("%d :  %s\n", ++i, (d->description)?(d->description):(d->name));
    }

    printf("number : ");
    scanf("%d", &no);

    if (!(no > 0 && no <= i)) {
        printf("number error\n");
        return 1;
    }

    for (d=alldevs, i=0; d; d=d->next) {
        if (no == ++i)  break;
    }

    if ((adhandle= pcap_open_live(d->name, 65536, 1, 1000, errbuf))==NULL) {
        printf("pcap_open_live error %s\n", d->name);
        pcap_freealldevs(alldevs);
        return -1;
    }

		printf("\nlistening on %s...\n", d->description);
    pcap_freealldevs(alldevs);

    pcap_loop(adhandle, 0, packet_handler, NULL);

    pcap_close(adhandle);

    return 0;
}

/* Callback function invoked by libpcap for every incoming packet */
void packet_handler(u_char *param, const struct pcap_pkthdr *header, const u_char *pkt_data)
{
	struct tm *tmp;
	char timestr[16];
	time_t local_tv_sec;


	/* convert the timestamp to readable format */
	local_tv_sec = header->ts.tv_sec;
	tmp = localtime(&local_tv_sec);

  printf("%2d/%2d %02d:%02d:%2d \n", tmp->tm_mon + 1, tmp->tm_mday, tmp->tm_hour, tmp->tm_min, tmp->tm_sec);
	if (header->len < 14) return;

	ether_header* pEther = (ether_header*)pkt_data;
	printf("%02X-%02X-%02X-%02X-%02X-%02X <- %02X-%02X-%02X-%02X-%02X-%02X ( type : %04X)(len : %d)\n",
		pEther->dst[0], pEther->dst[1], pEther->dst[2],
		pEther->dst[3], pEther->dst[4], pEther->dst[5],
		pEther->src[0], pEther->src[1], pEther->src[2],
		pEther->src[3], pEther->src[4], pEther->src[5], pEther->type, header->len

	);

	unsigned char ihl = *(pkt_data + sizeof(ether_header));
	ihl &= 0x0F;

	printf("(IHL : %02X) DST IP: %s\n ", ihl,
		inet_ntoa(*(struct in_addr*)(pkt_data + sizeof(ether_header) + 16)));


}
