function normalized_counts=SNLP_tfidf(counts,tf_normalization)

 if ~exist('tf_normalization')
     tf_normalization='log';
 end
 

normalized_counts=nan(size(counts));
counts_bin=counts;
counts_bin(counts>0)=1;
somma=sum(counts_bin,1);

if strcmp(tf_normalization,'log')
normalized_tf=1+log(counts);
else
normalized_tf=counts;
end

normalized_tf(counts==0)=0;
normalized_idf=log(size(counts,1)./somma);
normalized_counts=normalized_tf.*normalized_idf;

end
