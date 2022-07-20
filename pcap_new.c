#include <sys/time.h>
#include <netinet/in.h>
#include <net/ethernet.h>
#include <pcap/pcap.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <netinet/ip_icmp.h>

#define PROMISCUOUS 1
#define NONPROMISCUOUS 0

// IP 헤더 구조체
struct ip *iph;

// TCP 헤더 구조체
struct tcphdr *tcph;

// 패킷을 받아들일경우 이 함수를 호출한다.  
// packet 가 받아들인 패킷이다.
void packet_handler(u_char *useless, const struct pcap_pkthdr *pkthdr, 
                const u_char *packet)
{
    static int count = 1;
    struct ether_header *ep;
    unsigned short ether_type;    
    int chcnt =0;
    int length=pkthdr->len;

    // 이더넷 헤더를 가져온다. 
    ep = (struct ether_header *)packet;

    // IP 헤더를 가져오기 위해서 
    // 이더넷 헤더 크기만큼 offset 한다.   
    packet += sizeof(struct ether_header);

    // 프로토콜 타입을 알아낸다. 
    ether_type = ntohs(ep->ether_type);

    // 만약 IP 패킷이라면 
		// /usr/include/net/ethernet.h 
    if (ether_type == ETHERTYPE_IP)
    {
        // IP 헤더에서 데이타 정보를 출력한다.  
        iph = (struct ip *)packet;
        printf("IP 패킷\n");
        printf("Version     : %d\n", iph->ip_v);
        printf("Header Len  : %d\n", iph->ip_hl);
        printf("Ident       : %d\n", ntohs(iph->ip_id));
        printf("TTL         : %d\n", iph->ip_ttl); 
        printf("Src Address : %s     ", inet_ntoa(iph->ip_src));
        printf("Dst Address : %s\n", inet_ntoa(iph->ip_dst));

        // 만약 TCP 데이타 라면
        // TCP 정보를 출력한다. 
				// /usr/include/netinet/in.h
        if (iph->ip_p == IPPROTO_TCP)
        {
            tcph = (struct tcphdr *)(packet + iph->ip_hl * 4);
            printf("Src Port    : %d          " , ntohs(tcph->source));
            printf("Dst Port    : %d\n" , ntohs(tcph->dest));
        }
				else if (ip->ip_p == IPPROTO_SCTP)
				{
						printf(" SCTP PACKET \n");
				}


        // Packet 데이타 를 출력한다. 
        // IP 헤더 부터 출력한다.  
        while(length--)
        {
            printf("%02x", *(packet++)); 
            if ((++chcnt % 16) == 0) 
                printf("\n");
        }
    }
    // IP 패킷이 아니라면 
    else 
    {
       // printf("NONE IP 패킷\n");
    }
    printf("\n\n");
}    

int main(int argc, char **argv)
{
    char *dev;
    char *net;
    char *mask;

    bpf_u_int32 netp;
    bpf_u_int32 maskp;
    char errbuf[PCAP_ERRBUF_SIZE];
    int ret;
    struct pcap_pkthdr hdr;
    struct in_addr net_addr, mask_addr;
    struct ether_header *eptr;
    const u_char *packet;
		pcap_if_t *alldevs;
		pcap_if_t *d;
    int i, no;

    struct bpf_program fp;     

    pcap_t *pcd;  // packet capture descriptor

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


    // 디바이스 이름에 대한 네트웍/마스크 정보를 얻어온다. 
    ret = pcap_lookupnet(d->name, &netp, &maskp, errbuf);
    if (ret == -1)
    {
        printf("%s\n", errbuf);
        exit(1);
    }

    // 네트웍/마스트 정보를 점박이 3형제 스타일로 변경한다. 
    net_addr.s_addr = netp;
    net = inet_ntoa(net_addr);
    printf("NET : %s\n", net);

    mask_addr.s_addr = maskp;
    mask = inet_ntoa(mask_addr);
    printf("MSK : %s\n", mask);
    printf("=======================\n");

    // 디바이스 dev 에 대한 packet capture 
    // descriptor 를얻어온다.   
    pcd = pcap_open_live(d->name, BUFSIZ,  NONPROMISCUOUS, -1, errbuf);
    if (pcd == NULL)
    {
        printf("%s\n", errbuf);
        exit(1);
    }    

    printf("\nlistening on %s...\n", d->description);
    pcap_freealldevs(alldevs);

    pcap_loop(pcd, 0, packet_handler, NULL);

    pcap_close(pcd);

    
		return 0;
}
