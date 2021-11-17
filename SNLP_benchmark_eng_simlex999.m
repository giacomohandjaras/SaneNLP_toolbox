function [r,rho,coverage]=SNLP_benchmark_eng_simlex999(corpora,smoothing)

iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
coverage=100;

load 'SNLP_benchmark_eng_simlex999.mat';

if (isstruct(corpora)==0)
corpora=load(corpora);
end

%%%%troviamo le parole nel dizionario
[vectors_mask_col1] = SNLP_searchWords(word1, corpora.wordlist);
[vectors_mask_col2] = SNLP_searchWords(word2, corpora.wordlist);
vectors_mask=vectors_mask_col1.*vectors_mask_col2;

coverage=sum(vectors_mask)/numel(vectors_mask)*100;

similarity(find(vectors_mask==0))=[];
word1(find(vectors_mask==0))=[];
word2(find(vectors_mask==0))=[];
word1_stem(find(vectors_mask==0))=[];
word2_stem(find(vectors_mask==0))=[];


distances=nan(iterations,size(similarity,1));


for j=1:iterations
smooth=smoothing(j);

for i=1:size(similarity,1)

if(smooth>0)
wordvectors_extracted_col1 = SNLP_getWordVectorsSmoothed(word1(i), corpora.wordlist, corpora.vectors_matrix, word1_stem(i), corpora.wordlist_stem, smooth);
wordvectors_extracted_col2 = SNLP_getWordVectorsSmoothed(word2(i), corpora.wordlist, corpora.vectors_matrix, word2_stem(i), corpora.wordlist_stem, smooth);
else
wordvectors_extracted_col1 = SNLP_getWordVectors(word1(i), corpora.wordlist, corpora.vectors_matrix);
wordvectors_extracted_col2 = SNLP_getWordVectors(word2(i), corpora.wordlist, corpora.vectors_matrix);
end

distances(j,i)=1-pdist2(wordvectors_extracted_col1,wordvectors_extracted_col2,'cosine');

end
end


r=corr(similarity,distances');
rho=corr(similarity,distances','type','spearman');


end
