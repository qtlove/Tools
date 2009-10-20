#二、使用递归算法。据“F(i,j)=F(i-1,j-1)+F(i-1,j)”做递归计算每一个值。此算法在计算数据大时，非常慢。
     #include<stdio.h>
     #include<time.h>
     main()
     {
         int i, j, r, size, value;
         int yanghui( int i, int j );
         double start, finish, cost;
         printf( "Please input the SIZE: " );
         scanf( "%d", &size );
         start = (double)clock()/CLOCKS_PER_SEC;
         for( i=0; i<size; i++ )
         {
             for( r=0; r<size-i; r++ ) printf( "    " );
             for( j=0; j<=i; j++ )
             {
                 value = yanghui( i, j );
                 printf( " %d     ", value );

             printf( "\n" );

         finish = (double)clock()/CLOCKS_PER_SEC;
         cost = finish - start;
         printf( "\nCOST: %.6f\n", cost );

     int yanghui( int i, int j )
     {
         int value;
         if( j==0 || i==j )
             return 1;
         else
             value = yanghui( i-1, j-1 ) + yanghui( i-1, j );
         return value;
     }