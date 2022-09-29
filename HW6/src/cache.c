#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

#define DIRECT_MAPPED 0
#define FOUR_WAY_SET_ASSOCIATIVE 1
#define FULLY_ASSOCIATIVE 2
#define FIFO 0
#define LRU 1

typedef struct cache_block {
    bool valid;
    unsigned long long tag;
    int ref;
} cache_block;

int cache_size, block_size;
int associativity;
int algorithm;
int miss_count = 0;
int word_index_nbit;
int cache_index_nbit;
int tag_nbit;
cache_block *cache;

int *candidate_index(unsigned long long addr, int *len) {
    int *output;
    switch (associativity) {
    case DIRECT_MAPPED:
        *len = 1;
        output = (int *)malloc(sizeof(int) * *len);
        output[0] = (addr << tag_nbit) >> (tag_nbit + word_index_nbit);
        break;
    case FOUR_WAY_SET_ASSOCIATIVE:
        *len = 4;
        output = (int *)malloc(sizeof(int) * *len);
        for (int i = 0; i < 4; i++) {
            output[i] = i << cache_index_nbit ^
                (addr << tag_nbit) >> (tag_nbit + word_index_nbit);
        }
        break;
    case FULLY_ASSOCIATIVE:
        *len = cache_size / block_size;
        output = (int *)malloc(sizeof(int) * *len);
        for (int i = 0; i < *len; i++) {
            output[i] = i;
        }
        break;
    }
    return output;
}

unsigned long long get_tag(unsigned long long addr) {
    return addr >> (cache_index_nbit + word_index_nbit);
}

void update_ref(int index) {
    int n = cache_size / block_size;
    for (int i = 0; i < n; i++) {
        if (i != index && cache[i].valid) {
            if (cache[index].valid) {
                if (cache[i].ref < cache[index].ref) {
                    cache[i].ref++;
                }
            }
            else {
                cache[i].ref++;
            }
        }
    }
    cache[index].ref = 0;
}

// return true when there is victim
bool check_cache(unsigned long long addr, unsigned long long *victim_tag) {
    int len;
    int *index = candidate_index(addr, &len);
    unsigned long long tag = get_tag(addr);
    int victim_index = -1;
    int i = 0;
    for (; i < len; i++) {
        if (!cache[index[i]].valid) {
            // invalid, miss
            miss_count++;
            update_ref(index[i]);
            cache[index[i]].tag = tag;
            cache[index[i]].valid = true;
            break;
        }
        else {
            if (cache[index[i]].tag == tag) {
                // valid, hit
                switch (algorithm) {
                case FIFO:
                    break;
                case LRU:
                    update_ref(index[i]);
                    break;
                }
                break;
            }
            // valid, miss
            if (victim_index == -1) {
                victim_index = index[i];
            }
            else if (cache[index[i]].ref > cache[victim_index].ref) {
                victim_index = index[i];
            }
        }
    }
    free(index);
    if (i < len) {
        return false;
    }
    // valid, miss
    miss_count++;
    // replace victim
    *victim_tag = cache[victim_index].tag;
    update_ref(victim_index);
    cache[victim_index].tag = tag;
    return true;
}

// expecting n > 0
int integer_exp2(unsigned long long n) {
    int output = 0;
    while (n > 1) {
        output++;
        n >>= 1;
    }
    return output;
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(stderr, "usage: %s <trace.txt> <trace.out>\n", argv[0]);
        exit(1);
    }
    FILE *input_file = fopen(argv[1], "r");
    FILE *output_file = fopen(argv[2], "w");
    fscanf(input_file, "%d%d%d%d", &cache_size, &block_size, &associativity, &algorithm);
    if (block_size <= 0 || block_size & block_size - 1) {
        fprintf(stderr, "error: block_size should be power of 2\n");
        exit(1);
    }
    if (cache_size < block_size) {
        fprintf(stderr, "error: cache_size should be larger or equal to block_size\n");
        exit(1);
    }
    if (cache_size <= 0 || cache_size & cache_size - 1) {
        fprintf(stderr, "error: cache_size should be power of 2\n");
        exit(1);
    }
    switch (associativity) {
    case DIRECT_MAPPED:
        word_index_nbit = integer_exp2(block_size);
        cache_index_nbit = integer_exp2(cache_size / block_size);
        tag_nbit = integer_exp2(ULLONG_MAX) + 1 - word_index_nbit - cache_index_nbit;
        break;
    case FULLY_ASSOCIATIVE:
        word_index_nbit = integer_exp2(block_size);
        cache_index_nbit = 0;
        tag_nbit = integer_exp2(ULLONG_MAX) + 1 - word_index_nbit - cache_index_nbit;
        break;
    case FOUR_WAY_SET_ASSOCIATIVE:
        word_index_nbit = integer_exp2(block_size);
        cache_index_nbit = integer_exp2(cache_size / block_size) - 2;
        tag_nbit = integer_exp2(ULLONG_MAX) + 1 - word_index_nbit - cache_index_nbit;
        break;
    default:
        fprintf(stderr, "error: unknown associativity type\n");
        exit(1);
    }
    switch (algorithm) {
    case FIFO:
    case LRU:
        break;
    default:
        fprintf(stderr, "error: unknown algorithm\n");
        exit(1);
    }
    cache = (cache_block *)calloc(cache_size / block_size, sizeof(cache_block));
    int count = 0;
    unsigned long long addr;
    while (fscanf(input_file, "%llu", &addr) != EOF) {
        unsigned long long victim_tag;
        if (check_cache(addr, &victim_tag)) {
            fprintf(output_file, "%llu\n", victim_tag);
        }
        else {
            fprintf(output_file, "-1\n");
        }
        count++;
    }
    fprintf(output_file, "Miss rate = %f\n", (double)miss_count / (double)count);
    fclose(input_file);
    fclose(output_file);
    free(cache);
    return 0;
}
