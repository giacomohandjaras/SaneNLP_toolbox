function normalized_counts=SNLP_ppmi(counts)

normalized_counts=nan(size(counts));
tot_count=sum(counts(:));

prob_r=nan(size(counts,1),1);
prob_c=nan(size(counts,2),1);

for r=1:size(counts,1)
prob_r(r)=sum(counts(r,:))/tot_count;
end

for c=1:size(counts,2)
prob_c(c)=sum(counts(:,c))/tot_count;
end


for r=1:size(counts,1)
for c=1:size(counts,2)
prob_rc=counts(r,c)/tot_count;
ppmi=log2(prob_rc/(prob_r(r)*prob_c(c)));
normalized_counts(r,c)=max([0,ppmi]);
end
end


end
