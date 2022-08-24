function [r,rho,acc,RDM_behav,RDM_corpus,concepts_labels,coverage]=SNLP_benchmark_eng_vinson2008(corpus,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Test word-embeddings from a english-based corpus with behavioral feature-norming data from Vinson & Vigliocco, 2008.
%%%% 	Vinson, D. P., & Vigliocco, G. (2008).
%%%% 	Semantic feature production norms for a large set of objects and events.
%%%% 	Behavior Research Methods, 40(1), 183-190.
%%%%	doi: 10.3758/BRM.40.1.183
%%%%
%%%%Usage:
%%%%	[r,rho,acc,RDM_behav,RDM_corpus,concepts_labels,coverage]=SNLP_benchmark_eng_vinson2008(corpus,smoothing)
%%%%
%%%%	corpus: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	         or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT)
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	r: the Pearson's correlation coefficient between the RDM from word-embeddings of the corpus
%%%%	   (cosine distance) and the RDM (cosine distance) obtained from behavioral data.
%%%%	rho: as above but using Spearman's rho.
%%%%	acc: accuracy evaluated with a similarity encoding analysis (see SNLP_similarity_encoding).
%%%%	RDM_behav: RDM (cosine distance) obtained from behavioral data
%%%%	RDM_corpus: RDM (cosine distance) obtained from word-embeddings
%%%%	concepts_labels: the labels of the stimuli used to generate RDM_behav and RDM_corpus
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in behavioral data could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in behavioral data and the corpus.
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
acc=nan(iterations,1);
RDM_behav=[];
RDM_corpus=[];
coverage=[];

load 'SNLP_benchmark_eng_vinson2008.mat';

if (isstruct(corpus)==0)
    corpus=load(corpus);
end

%%%%Find the words in the dictionary of word-embeddings
[vectors_mask] = SNLP_searchWords(vectors_labels, corpus.wordlist);

vectors_matrix(find(vectors_mask==0),:)=[];
vectors_labels(find(vectors_mask==0))=[];
vectors_labels_stem(find(vectors_mask==0))=[];

concepts_labels=vectors_labels;
coverage=sum(vectors_mask)/numel(vectors_mask)*100;

%%%%remove features with zero occurrences
vectors_mask=(sum(vectors_matrix)==0);
vectors_matrix(:,find(vectors_mask==1))=[];

normalized_occurrences=SNLP_tfidf(vectors_matrix);
RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpus=nan(iterations,numel(RDM_behav));

for j=1:iterations
    smooth=smoothing(j);
    
    if(smooth>0)
        wordvectors_extracted = SNLP_getWordVectorsSmoothed(vectors_labels, corpus.wordlist, corpus.vectors_matrix, vectors_labels_stem, corpus.wordlist_stem, smooth);
    else
        wordvectors_extracted = SNLP_getWordVectors(vectors_labels, corpus.wordlist, corpus.vectors_matrix);
    end
    
    RDM_cor=pdist(wordvectors_extracted,'cosine');
    r(j)=corr(RDM_behav',RDM_cor');
    rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
    [~, accuracy_tot] = SNLP_similarity_encoding(squareform(RDM_cor), squareform(RDM_behav), 'correlation');
    acc(j)=accuracy_tot;
    RDM_corpus(j,:)=RDM_cor;
    
end

end
