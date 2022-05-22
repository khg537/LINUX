#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define 	POISON_POINTER_DELTA   0
#define 	LIST_POISON1   ((void *) 0x00100100 + POISON_POINTER_DELTA)
#define 	LIST_POISON2   ((void *) 0x00200200 + POISON_POINTER_DELTA)

#define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)

#define container_of(ptr, type, member) ({			\
	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
	(type *)( (char *)__mptr - offsetof(type,member) );})

#define INIT	1
#define FIND	2
#define ADD		3


int num_page;

//-------------------------------------------------------------

struct list_head {
	struct  list_head *next, *prev;
};


void __list_add(struct list_head *new,
		struct list_head *prev,
		struct list_head *next)
{
	next->prev = new;
	new->next = next;
	new->prev = prev;
	prev->next = new;
}

void list_add( struct list_head *new, 
				struct list_head *head )
{
		__list_add(new, head, head->next);
}

void list_add_tail(struct list_head *new, struct list_head *head)
{
	    __list_add(new, head->prev, head);
}

void __list_del(struct list_head *prev, struct list_head *next)
{
	next->prev = prev;
	prev->next= next;
}

void __list_del_entry(struct list_head *entry)
{
	
	__list_del(entry->prev, entry->next);
}

void list_del(struct list_head *entry)
{
	__list_del_entry(entry);
}

//---------------------------------------------------------------------

struct hlist_head {
	struct hlist_node *first;
};

struct hlist_node {
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

void __hlist_del(struct hlist_node *n)
{
	struct hlist_node *next = n->next;
	struct hlist_node **pprev = n->pprev;

	*pprev =  next;
	if (next)
		next->pprev= pprev;
}

void hlist_del(struct hlist_node *n)
{
	__hlist_del(n);
	n->next = LIST_POISON1;
	n->pprev = LIST_POISON2;
}

#define  HASH_MAX   8

#define GOLDEN_RATIO_PRIME_32 0x9e370001UL

unsigned int hash_32(unsigned int val, unsigned int bits)
{
	unsigned int hash = val * GOLDEN_RATIO_PRIME_32;
	return hash >> (32 - bits);
}

#define pid_hashfn(pid)  \
	    hash_32( pid, 3 )

//---------------------------------------------------------------

struct page
{
	int pfn;
	int data;

	struct hlist_node hnode;
	struct list_head list;
};

int hash_pfn( int pfn )
{
	return hash_32( pfn, 3 );
}

void display( struct hlist_head *heads , struct list_head *head)
{
	int i;
	
	struct hlist_node *temp;

	struct page *p;


	printf("[HASH TABLE]\n");
	for( i=0; i<HASH_MAX; i++ )
	{
		printf("[%d]", i );
		for( temp = heads[i].first; temp!= 0; temp=temp->next)
		{
			p = container_of( temp, struct page, hnode );
			printf("<->[%d]", p->pfn );
		}
		printf("\n");

	}

	struct list_head *temp_list;

	printf("\n\n[LRU LIST]\n");
	printf("[lru]");

	for (temp_list = head->next ; temp_list!= head ; temp_list = temp_list->next)
	{
		p = container_of(temp_list, struct page, list);
		printf("<->[%d]",p->pfn); 
	}
	printf("\n");

	getchar();

}

int  check_hash(int pfn, struct hlist_head *h)
{
	struct hlist_node *temp;

	struct page *p;
	
	for (temp = h->first ; temp ; temp = temp->next)
	{
		p = container_of( temp, struct page, hnode );
		if (p->pfn == pfn)
		{
			hlist_del(temp);
						
			return p->data;
		}
	}
	return 0;
}

void list_search_n_delete(int val, struct list_head *h)	
{
	struct list_head *temp;
	struct page *p;

	struct list_head *temp1;
	struct list_head *temp2;
	for (temp = h->next ; temp != h ; temp = temp->next)
	{
		p = container_of( temp, struct page, list);
		if (p!=NULL && p->pfn == val)
		{
			list_del(&p->list);
		}
	}
}
	
int get_pfn()
{
	srand((unsigned)time(NULL));
	return rand()%39;
}

int get_last_pfn(struct list_head* head)
{
	struct list_head *cur;
	struct page *p;
	
	cur = head->next;
	while ( cur != head->prev)
	{
		cur = cur->next;

	}

	p = container_of( cur, struct page, list );
	list_del(&p->list);
	
	return p->pfn;
		
}

int main()
{
	struct hlist_head heads[ HASH_MAX ] = {0,};
	struct list_head head = {&head, &head};

	struct page p[40] = {0,};
	int i;
	int pfn, last_pfn;
	int data;
	
	struct page *ptr = 0;

	for (i = 0 ; i < 40 ; i++)
	{
		p[i].pfn = i;
		p[i].data = i + 1000;
	}

	
	display(heads, &head);
	for (i = 0 ;  ; i++)	
	{
		system("clear");
		pfn =get_pfn();
		
		if ((data = check_hash(pfn, &heads[hash_pfn(pfn)])) != 0)
		{

			printf("pfn = %d 접근\n", pfn);
			printf("기존 페이지 접근, data = %d\n", data); 
			
			hlist_add_head( &p[pfn].hnode, &heads[hash_pfn(pfn)]);
			list_search_n_delete(pfn, &head);	
			list_add( &p[pfn].list, &head);
			display(heads, &head);
			continue;

		}
		else
		{
			if (num_page < 20)
			{
				num_page++;
				printf("pfn = %d 접근\n", pfn);
				printf("새로운 page hash에 추가. 현재 page 수 = %d\n",num_page);
				hlist_add_head( &p[pfn].hnode, &heads[hash_pfn(pfn)]);
				list_add( &p[pfn].list, &head);
				display(heads, &head);
			}
			else
			{
				last_pfn = get_last_pfn(&head);
				printf("pfn = %d 접근\n", pfn);
				printf("page 꽉참. pfn = %d 퇴출\n", last_pfn);
				printf("새로운 page hash에 추가, 현재 page 수 = %d\n", num_page);
				(void)check_hash(last_pfn, &heads[hash_pfn(last_pfn)]);


				hlist_add_head( &p[pfn].hnode, &heads[hash_pfn(pfn)]);
				list_add( &p[pfn].list, &head);

				display(heads, &head);
			}

		}
	
	}

	return 0;
}
