%% General file folder path

PATHSTR= 'C:\Vis_Stimuli_SH_v1';
a=load([PATHSTR '\RFreps.txt']); 
b=a(randperm(size(a,1)),:); 
writematrix(b,[PATHSTR '\RFreps_random1.txt'],'Delimiter','tab');
c=b(randperm(size(a,1)),:); 
writematrix(c,[PATHSTR '\RFreps_random2.txt'],'Delimiter','tab');
d=c(randperm(size(a,1)),:); 
writematrix(d,[PATHSTR '\RFreps_random3.txt'],'Delimiter','tab');
e=d(randperm(size(a,1)),:); 
writematrix(e,[PATHSTR '\RFreps_random4.txt'],'Delimiter','tab');
f=e(randperm(size(a,1)),:); 
writematrix(f,[PATHSTR '\RFreps_random5.txt'],'Delimiter','tab');
g=f(randperm(size(a,1)),:); 
writematrix(g,[PATHSTR '\RFreps_random6.txt'],'Delimiter','tab');
h=g(randperm(size(a,1)),:); 
writematrix(h,[PATHSTR '\RFreps_random7.txt'],'Delimiter','tab');
i=h(randperm(size(a,1)),:); 
writematrix(i,[PATHSTR '\RFreps_random8.txt'],'Delimiter','tab');
j=i(randperm(size(a,1)),:); 
writematrix(j,[PATHSTR '\RFreps_random9.txt'],'Delimiter','tab');
k=j(randperm(size(a,1)),:); 
writematrix(k,[PATHSTR '\RFreps_random10.txt'],'Delimiter','tab');