function [r,rho,acc,RDM_behav,RDM_corpora,concepts_labels,coverage]=SNLP_benchmark_eng_mcrae2005(corpora,smoothing)

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_behav=[];
RDM_corpora=[];

load 'SNLP_benchmark_eng_mcrae2005.mat';



%%%%%apriamo un corpora di riferimento, per prendere al volo il vocabolario
if (isstruct(corpora)==0)
corpora=load(corpora);
end
[vectors_mask] = SNLP_searchWords(concepts_labels, corpora.wordlist);

concepts_labels(find(vectors_mask==0))=[];
concepts_labels_stem(find(vectors_mask==0))=[];
occurrences(find(vectors_mask==0),:)=[];
coverage=sum(vectors_mask)/numel(vectors_mask)*100;

%%%%filtriamo perchè ci potrebbe essere ora delle features a zero frequenza
occurrences_isnan=sum(occurrences,1);
occurrences(:,occurrences_isnan==0)=[];

normalized_occurrences=SNLP_tfidf(occurrences);

RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpora=nan(iterations,numel(RDM_behav));


for j=1:iterations
smooth=smoothing(j);

if(smooth>0)
wordvectors_extracted = SNLP_getWordVectorsSmoothed(concepts_labels, corpora.wordlist, corpora.vectors_matrix, concepts_labels_stem, corpora.wordlist_stem, smooth);
else
wordvectors_extracted = SNLP_getWordVectors(concepts_labels, corpora.wordlist, corpora.vectors_matrix);
end
RDM_cor=pdist(wordvectors_extracted,'cosine');

r(j)=corr(RDM_behav',RDM_cor');
rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
[~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_cor), squareform(RDM_behav), 'correlation');
acc(j)=accuracy_tot;
RDM_corpora(j,:)=RDM_cor;

end



end
