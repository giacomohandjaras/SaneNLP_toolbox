function [r,rho,acc,RDM_behav,RDM_corpora,concepts_labels,coverage]=SNLP_benchmark_eng_vinson2008(corpora,smoothing)

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_behav=[];
RDM_corpora=[];
coverage=[];

load 'SNLP_benchmark_eng_vinson2008.mat';


if (isstruct(corpora)==0)
corpora=load(corpora);
end

%%%%troviamo le parole nel dizionario
[vectors_mask] = SNLP_searchWords(vectors_labels, corpora.wordlist);

vectors_matrix(find(vectors_mask==0),:)=[];
vectors_labels(find(vectors_mask==0))=[];
vectors_labels_stem(find(vectors_mask==0))=[];

concepts_labels=vectors_labels;
coverage=sum(vectors_mask)/numel(vectors_mask)*100;

%%%%filtriamo perchè ci potrebbe essere ora delle features a zero frequenza
vectors_mask=(sum(vectors_matrix)==0);
vectors_matrix(:,find(vectors_mask==1))=[];


normalized_occurrences=SNLP_tfidf(vectors_matrix);
RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpora=nan(iterations,numel(RDM_behav));


for j=1:iterations
smooth=smoothing(j);

if(smooth>0)
wordvectors_extracted = SNLP_getWordVectorsSmoothed(vectors_labels, corpora.wordlist, corpora.vectors_matrix, vectors_labels_stem, corpora.wordlist_stem, smooth);
else
wordvectors_extracted = SNLP_getWordVectors(vectors_labels, corpora.wordlist, corpora.vectors_matrix);
end

RDM_cor=pdist(wordvectors_extracted,'cosine');
r(j)=corr(RDM_behav',RDM_cor');
rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
[~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_cor), squareform(RDM_behav), 'correlation');
acc(j)=accuracy_tot;
RDM_corpora(j,:)=RDM_cor;

end


end
