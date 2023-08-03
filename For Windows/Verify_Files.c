#include<stdio.h>
int main()
{
    char file1[200], file2[200];
    printf("Enter first file's name/path to file:\n");
    scanf("%s",file1);
    printf("Enter Second file's name/path to file:\n");
    scanf("%s",file2);

    FILE* reader = fopen(file1,"rb");
    FILE* reader2 = fopen(file2,"rb");
    if(reader==NULL)
    {
        printf("\nError in opening/finding the file %s",file1);
        return 0;
    }
    if(reader2==NULL)
    {
        printf("\nError in opening/finding the file %s",file2);
        return 0;
    }
    unsigned char check=0,in[1],out[1];
    unsigned long long int count=0,size;

    fseeko64(reader,0,SEEK_END);
    size= ftello64(reader);
    fseeko64(reader,0,SEEK_SET);

    printf("Checking files...\n");

    while (count<size)
    {
        fread(in,1,1,reader);
        fread(out,1,1,reader2);
        check = in[0]^out[0];
        if(check)
        {
            printf("\nERROR \n\nFound at byte %llu",count);
            goto jump;
        }
        count++;
    }
    printf("\nNO ERROR\n\n%llu bytes verified",count);
    jump:
    fclose(reader);
    fclose(reader2);
    
}