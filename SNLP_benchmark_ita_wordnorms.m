function [r,rho,acc,RDM_behav,RDM_corpora,concepts_labels,coverage]=SNLP_benchmark_ita_wordnorms(corpora,smoothing)

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_behav=[];
RDM_corpora=[];
coverage=[];

load 'SNLP_benchmark_ita_wordnorms.mat';


%%%%%apriamo un corpora di riferimento, per prendere al volo il vocabolario
if (isstruct(corpora)==0)
corpora=load(corpora);
end

[vectors_mask] = SNLP_searchWords(words_ita, corpora.wordlist);

all_words(find(vectors_mask==0))=[];
words_ita_stem(find(vectors_mask==0))=[];
words_ita(find(vectors_mask==0))=[];
num_of_stim=numel(words_ita);

concepts_labels=words_ita;
coverage=sum(vectors_mask)/numel(vectors_mask)*100;


%%%%%Tokeniziamo i documenti e normaliziamo e calcoliamo il cosine
documents = tokenizedDocument(all_words);
bag = bagOfWords(documents);

normalized_occurrences=full(tfidf(bag,'TFWeight','log','IDFWeight','normal'));
RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpora=nan(iterations,numel(RDM_behav));

for j=1:iterations
smooth=smoothing(j);

if(smooth>0)
wordvectors_extracted = SNLP_getWordVectorsSmoothed(words_ita, corpora.wordlist, corpora.vectors_matrix, words_ita_stem, corpora.wordlist_stem, smooth);
else
wordvectors_extracted = SNLP_getWordVectors(words_ita, corpora.wordlist, corpora.vectors_matrix);
end
RDM_cor=pdist(wordvectors_extracted,'cosine');

r(j)=corr(RDM_behav',RDM_cor');
rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
%[~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_cor), squareform(RDM_behav), 'correlation');
%acc(j)=accuracy_tot;
RDM_corpora(j,:)=RDM_cor;
end



end
