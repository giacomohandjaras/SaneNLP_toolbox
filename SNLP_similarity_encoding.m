function [accuracy_temp, accuracy_tot]=SNLP_similarity_encoding(A,B,distance)

elements=size(A,1);
accuracy_temp=zeros(elements,elements);
accuracy_tot=nan(1,1);


pairings=nan(elements*(elements-1)/2,2);
index=1;
for i=1:elements
for j=(i+1):elements
pairings(index,:)=[i,j];
index=index+1;
end
end
index=index-1;

score_tot=0;
for i=1:index
pair=pairings(i,:);
A_sel=A(pair,:);
B_sel=B(pair,:);
A_sel(:,pair)=[];
B_sel(:,pair)=[];

distances_temp=pdist2(A_sel,B_sel,distance);

[~,min_indx]=min(distances_temp);

score=0;
if(min_indx(1)==1); score=score+1; end
if(min_indx(2)==2); score=score+1; end
accuracy_temp(pairings(i,1),pairings(i,2))=score;
accuracy_temp(pairings(i,2),pairings(i,1))=score;

score_tot=score_tot+score;
end

accuracy_tot=score_tot/(index*2);

end
