function RDM_sorted=SNLP_reorderRDM(RDM, sort_order)


dim=size(RDM,1);
RDM_sorted=nan(dim,dim);


for i=1:dim
for j=(i+1):dim
RDM_sorted(i,j)=RDM(sort_order(i),sort_order(j));
RDM_sorted(j,i)=RDM_sorted(i,j);
end
end

for i=1:dim
RDM_sorted(i,i)=RDM(sort_order(i),sort_order(i));
end

end
