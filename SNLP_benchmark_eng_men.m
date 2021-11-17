function [r,rho,coverage]=SNLP_benchmark_eng_men(corpora,smoothing)

iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
coverage=100;

load 'SNLP_benchmark_eng_men.mat';

if (isstruct(corpora)==0)
corpora=load(corpora);
end

%%%%troviamo le parole nel dizionario
[vectors_mask_col1] = SNLP_searchWords(concepts_labels_col1, corpora.wordlist);
[vectors_mask_col2] = SNLP_searchWords(concepts_labels_col2, corpora.wordlist);
vectors_mask=vectors_mask_col1.*vectors_mask_col2;

ratings(find(vectors_mask==0))=[];
concepts_labels_col1(find(vectors_mask==0))=[];
concepts_labels_col2(find(vectors_mask==0))=[];
concepts_labels_col1_stem(find(vectors_mask==0))=[];
concepts_labels_col2_stem(find(vectors_mask==0))=[];

coverage=sum(vectors_mask)/numel(vectors_mask)*100;

distances=nan(iterations,size(ratings,1));

for j=1:iterations
smooth=smoothing(j);

for i=1:size(ratings,1)

if(smooth>0)
wordvectors_extracted_col1 = SNLP_getWordVectorsSmoothed(concepts_labels_col1(i), corpora.wordlist, corpora.vectors_matrix, concepts_labels_col1_stem(i), corpora.wordlist_stem, smooth);
wordvectors_extracted_col2 = SNLP_getWordVectorsSmoothed(concepts_labels_col2(i), corpora.wordlist, corpora.vectors_matrix, concepts_labels_col2_stem(i), corpora.wordlist_stem, smooth);
else
wordvectors_extracted_col1 = SNLP_getWordVectors(concepts_labels_col1(i), corpora.wordlist, corpora.vectors_matrix);
wordvectors_extracted_col2 = SNLP_getWordVectors(concepts_labels_col2(i), corpora.wordlist, corpora.vectors_matrix);
end

distances(j,i)=1-pdist2(wordvectors_extracted_col1,wordvectors_extracted_col2,'cosine');

end
end


r=corr(ratings,distances');
rho=corr(ratings,distances','type','spearman');

end
