#include <stdio.h>
#include <stdlib.h>

#define offsetof(TYPE, MEMBER) ((size_t)&((TYPE *)0)->MEMBER)

#define container_of(ptr, type, member) ({      \
        const typeof( ((type *)0)->member ) *__mptr = (ptr); \
        (type *)( (char *)__mptr - offsetof(type, member) );})

struct hlist_head{
    struct hlist_node *first;
};

struct hlist_node{
    struct hlist_node *next, **pprev;
};

void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
{
    struct hlist_node *first = h->first;
    n->next = first;

    if (first)
        first->pprev = &n->next;

    h->first = n;
    n->pprev = &h->first;
}

//------------------------------------------------

#define HASH_MAX    8


typedef struct
{
    int sno;
    struct hlist_node hash;
} SAWON;

int hash_sno(int sno)
{
    return sno % HASH_MAX;
}

void display( struct hlist_head *heads)
{
    int i;
    SAWON *s;
    struct hlist_node *temp;

    system("clear");

    for ( i = 0; i < HASH_MAX ; i++)
    {
        printf("[%d]", i);
        for (temp = heads[i].first; temp; temp= temp->next)
        {
            s = container_of( temp, SAWON, hash);
            printf("<->[%d]", s->sno);
        }
        printf("\n");
    }
    getchar();
}

int main()
{
    struct hlist_head heads[ HASH_MAX ] = {0,};
    SAWON s[30] = {0, };
    int sno;

    display(heads);
    for (int i = 0; i < 30 ; i++)
    {
        sno = 1000 + i;
        s[i].sno = sno;
        hlist_add_head(&s[i].hash, &heads[hash_sno(sno)]);
        display(heads);
    }

    return  0;
}
