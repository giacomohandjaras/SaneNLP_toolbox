function normalized_counts=SNLP_tfidf(counts)

normalized_counts=nan(size(counts));

counts_bin=counts;
counts_bin(counts>0)=1;
somma=sum(counts_bin,1);

normalized_tf=1+log(counts);
normalized_tf(counts==0)=0;
normalized_idf=log(size(counts,1)./somma);
normalized_counts=normalized_tf.*normalized_idf;

end
