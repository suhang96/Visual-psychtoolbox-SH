%% General file folder path
fun=mfilename;
PATHSTR= fileparts(which(fun));
a=load([PATHSTR '\Size_10reps.txt']); 
b=a(randperm(size(a,1)),:); 
writematrix(b,[PATHSTR '\Size_10reps_random1.txt'],'Delimiter','tab');
c=b(randperm(size(a,1)),:); 
writematrix(c,[PATHSTR '\Size_10reps_random2.txt'],'Delimiter','tab');
d=c(randperm(size(a,1)),:); 
writematrix(d,[PATHSTR '\Size_10reps_random3.txt'],'Delimiter','tab');
e=d(randperm(size(a,1)),:); 
writematrix(e,[PATHSTR '\Size_10reps_random4.txt'],'Delimiter','tab');
f=e(randperm(size(a,1)),:); 
writematrix(f,[PATHSTR '\Size_10reps_random5.txt'],'Delimiter','tab');
g=f(randperm(size(a,1)),:); 
writematrix(g,[PATHSTR '\Size_10reps_random6.txt'],'Delimiter','tab');
h=g(randperm(size(a,1)),:); 
writematrix(h,[PATHSTR '\Size_10reps_random7.txt'],'Delimiter','tab');
i=h(randperm(size(a,1)),:); 
writematrix(i,[PATHSTR '\Size_10reps_random8.txt'],'Delimiter','tab');
j=i(randperm(size(a,1)),:); 
writematrix(j,[PATHSTR '\Size_10reps_random9.txt'],'Delimiter','tab');
k=j(randperm(size(a,1)),:); 
writematrix(k,[PATHSTR '\Size_10reps_random10.txt'],'Delimiter','tab');