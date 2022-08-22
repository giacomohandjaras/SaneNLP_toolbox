function normalized_counts=SNLP_tfidf(counts,tf_normalization);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Normalize a matrix of occurences using term frequency–inverse document frequency 
%%%% 	tf-idf is a numerical statistic that is intended to reflect how important a word is to a document in a collection or corpus
%%%% 	see: https://en.wikipedia.org/wiki/Tf–idf
%%%%
%%%%Usage: 
%%%%	[normalized_counts]=SNLP_tfidf(counts,tf_normalization)
%%%%
%%%%	counts: a matrix documents by tokens containing the raw occurrences of each token in each document
%%%%	tf_normalization: if tf_normalization is defined with 'log', occurrences will be log transformed.
%%%%
%%%%	normalized_counts: the output is the normalized matrix
%%%%	
%%%%	
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
