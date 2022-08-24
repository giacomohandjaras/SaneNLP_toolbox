function [r,rho,coverage,RDM_behav,RDM_corpus,concepts_labels]=SNLP_benchmark_eng_lenci2013(corpus,smoothing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Test word-embeddings from a english-based corpus with behavioral feature-norming data from Lenci et al., 2013.
%%%% 	Lenci, A., Baroni, M., Cazzolli, G., & Marotta, G. (2013).
%%%% 	BLIND: A set of semantic feature norms from the congenitally blind.
%%%% 	Behavior research methods, 45(4), 1218-1233.
%%%%	doi: 10.3758/s13428-013-0323-4
%%%%
%%%%Usage:
%%%%	[r,rho,coverage,RDM_behav,RDM_corpus,concepts_labels]=SNLP_benchmark_eng_lenci2013(corpus,smoothing)
%%%%
%%%%	corpus: a char variable indicating the filename of a .mat containing word2vec embeddings
%%%%	         or directly the struct containing word-embeddings (see SNLP_convertW2VtoMAT)
%%%%	smoothing: a positive float (generally between 0 and 1) or an array of positive floats indicating the level of gaussian smoothings
%%%%	           (sigma of a distro centered on a cosine distance of 0) to be tested (see SNLP_getWordVectorsSmoothed)
%%%%
%%%%	r: the Pearson's correlation coefficient between the RDM from word-embeddings of the corpus
%%%%	   (cosine distance) and the RDM (cosine distance) obtained from behavioral data.
%%%%	rho: as above but using Spearman's rho.
%%%%	coverage: since the vocabulary of the word-embeddings depends on the size of the corpus,
%%%%	          some words present in behavioral data could not be represented in the word-embeddings.
%%%%	          Coverage measures the overlap in % between the words in behavioral data and the corpus.
%%%%	RDM_behav: RDM (cosine distance) obtained from behavioral data
%%%%	RDM_corpus: RDM (cosine distance) obtained from word-embeddings
%%%%	concepts_labels: the labels of the stimuli used to generate RDM_behav and RDM_corpus
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concepts_labels={};
iterations=numel(smoothing);
r=nan(iterations,1);
rho=nan(iterations,1);
RDM_behav=[];
RDM_corpus=[];

load 'SNLP_benchmark_eng_lenci2013.mat';

%%%%%Open the corpus
if (isstruct(corpus)==0)
    corpus=load(corpus);
end
[vectors_mask] = SNLP_searchWords(concepts_labels, corpus.wordlist);

concepts_labels(find(vectors_mask==0))=[];
concepts_labels_stem(find(vectors_mask==0))=[];
occurrences(find(vectors_mask==0),:)=[];
coverage=sum(vectors_mask)/numel(vectors_mask)*100;

%%%%remove features with zero occurrences
occurrences_isnan=sum(occurrences,1);
occurrences(:,occurrences_isnan==0)=[];

normalized_occurrences=SNLP_tfidf(occurrences);

RDM_behav=pdist(normalized_occurrences,'cosine');
RDM_corpus=nan(iterations,numel(RDM_behav));


for j=1:iterations
    smooth=smoothing(j);
    
    if(smooth>0)
        wordvectors_extracted = SNLP_getWordVectorsSmoothed(concepts_labels, corpus.wordlist, corpus.vectors_matrix, concepts_labels_stem, corpus.wordlist_stem, smooth);
    else
        wordvectors_extracted = SNLP_getWordVectors(concepts_labels, corpus.wordlist, corpus.vectors_matrix);
    end
    RDM_cor=pdist(wordvectors_extracted,'cosine');
    
    r(j)=corr(RDM_behav',RDM_cor');
    rho(j)=corr(RDM_behav',RDM_cor','type','spearman');
    RDM_corpus(j,:)=RDM_cor;
end

end
