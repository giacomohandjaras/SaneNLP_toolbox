function normalized_counts=SNLP_ppmi(counts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Normalize a matrix of occurences using positive-pointwise-mutual-information
%%%% 	Please refers to:
%%%% 	 	Bullinaria, J. A., & Levy, J. P. (2007). Extracting semantic representations from word co-occurrence statistics: A computational study. Behavior research methods, 39(3), 510-526.
%%%%
%%%%Usage:
%%%%	normalized_counts=SNLP_ppmi(counts)
%%%%
%%%%	counts: a matrix documents by tokens containing the raw occurrences of each token in each document
%%%%
%%%%	normalized_counts: the output is the normalized matrix
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
