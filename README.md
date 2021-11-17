# SaneNLP_toolbox

#################################################<br>
MATLAB TOOLBOX for NLP by SANE <br>
#################################################<br>

<i>bigrams_eng.txt</i>: a lists of common (in our internal corpus) english bigrams

<i>bigrams_ita.txt</i>: a lists of common (in our internal corpus) italian bigrams

<i>stop_words_large_eng.txt</i>: common stop words in english

<i>stop_words_large_ita.txt</i>: common stop words in italian


<i>SNLP_benchmark_eng_lenci2013.m</i>: compare external word-embeddings/RDM with the one from the behavioral experiment of Lenci et al., 2013 (doi:10.3758/s13428-013-0323-4) <br>
<i>SNLP_benchmark_eng_lenci2013.mat</i>: the workspace containing raw data from Lenci et al., 2013

<i>SNLP_benchmark_eng_mcrae2005.m</i>: compare external word-embeddings/RDM with the one from the behavioral experiment of McRae et al., 2005 (doi:10.3758/BF03192726) <br>
<i>SNLP_benchmark_eng_mcrae2005.mat</i>: the workspace containing raw data from McRae et al., 2005

<i>SNLP_benchmark_eng_men.m</i>: compare external word-embeddings/RDM with the one from the MEN dataset of Bruni & Baroni, 2013 (doi:110.1613/jair.4135) <br>
<i>SNLP_benchmark_eng_men.mat</i>: the workspace containing raw data from Bruni et al., 2013. Check also performance here: https://aclweb.org/aclwiki/MEN_Test_Collection_(State_of_the_art)

<i>SNLP_benchmark_eng_rg65.m</i>: compare external word-embeddings/RDM with the one from Rubenstein & Goodenough (RG-65) dataset (doi:10.1145/365628.365657) <br>
<i>SNLP_benchmark_eng_rg65.mat</i>: the workspace containing raw data from Rubenstein & Goodenough, 1965. Check also performance here: https://aclweb.org/aclwiki/RG-65_Test_Collection_(State_of_the_art)

<i>SNLP_benchmark_eng_simlex999.m</i>: compare external word-embeddings/RDM with the one from SIMLEX-999 of Hill et al., 2014 (doi:10.1162/COLI_a_00237) <br>
<i>SNLP_benchmark_eng_simlex999.mat</i>: the workspace containing raw data from SIMLEX-999  Check also performance here: https://aclweb.org/aclwiki/SimLex-999_(State_of_the_art)

<i>SNLP_benchmark_eng_toefl.m</i>: compare external word-embeddings/RDM with the one from TOEFL Synonym Questions (http://lsa.colorado.edu/) <br>
<i>SNLP_benchmark_eng_toefl.mat</i>: the workspace containing raw data of the TOEFL Synonym Questions. Check also performance here: https://aclweb.org/aclwiki/TOEFL_Synonym_Questions_(State_of_the_art)

<i>SNLP_benchmark_eng_vinson2008.m</i>: compare external word-embeddings/RDM with the one from the behavioral experiment of Vinson & Vigliocco, 2008 (doi:10.3758/BRM.40.1.183) <br>
<i>SNLP_benchmark_eng_vinson2008.mat</i>: the workspace containing raw data from Vinson & Vigliocco, 2008

<i>SNLP_benchmark_eng_wordnorms.m</i>: compare external word-embeddings/RDM with the one from the behavioral experiment of Buchanan et al. semantic word-pair norms (2013) (doi:10.3758/s13428-012-0284-z) <br>
<i>SNLP_benchmark_eng_wordnorms.mat</i>: the workspace containing raw data from Buchanan et al., 2013.

<i>SNLP_benchmark_eng_ws353.m</i>: compare external word-embeddings/RDM with the one from WordSimilarity-353 Test Collection from Finkelstein et al., 2002 (doi:10.1145/371920.372094) <br>
<i>SNLP_benchmark_eng_ws353.mat</i>: the workspace containing raw data from WordSimilarity-353. Check also performance here: https://aclweb.org/aclwiki/WordSimilarity-353_Test_Collection_(State_of_the_art)

<i>SNLP_benchmark_ita_wordnorms.m</i>: compare external word-embeddings/RDM with the one from the behavioral experiment of Buchanan et al. semantic word-pair norms (2013) in translated in italian by ours <br>
<i>SNLP_benchmark_ita_wordnorms.mat</i>: the workspace containing raw data from Buchanan et al., 2013, translated in italian by ours


<i>SNLP_convertW2VtoMAT.m</i>: convert txt word2vec embedding matrix in a matlab matrix <br>
<i>SNLP_getOccurrence_concepts.m</i>: extract frequencies and ranks from a dictionary file, using stemming to aggregate information across words <br>
<i>SNLP_getOccurrence.m</i>: extract frequencies and ranks from a dictionary file <br>
<i>SNLP_get_R1R2.m</i>: a sub-function used to extract the root of a word during stemming procedure <br>
<i>SNLP_getUniqueWords.m</i>: return the unique words in a document <br>
<i>SNLP_getWordVectors.m</i>: return the word embedding vectors from a word2vec matlab matrix <br>
<i>SNLP_getWordVectorsSmoothed.m</i>: return the word embedding vectors from a word2vec matlab matrix, including a smoothing procedure based on stemming <br>
<i>SNLP_is_short_word.m</i>: if a word is short or not <br>
<i>SNLP_isStopWord.m</i>: if a word is a stop or not <br>
<i>SNLP_loadWords.m</i>: load a list of words from an external txt file <br>
<i>SNLP_ppmi.m</i>: evaluate from a matrix of occurences the positive pointwise mutual information <br>
<i>SNLP_removeExtraGarbage.m</i>: remove non-ASCII characters from a string: do not use this function unless you know the risks! <br>
<i>SNLP_removeExtraSpaces.m</i>: remove two or more consecutive spaces in a string <br>
<i>SNLP_removeNewLine.m</i>: remove newlines in a string <br>
<i>SNLP_removeNumbers.m</i>: remove numbers from a string <br>
<i>SNLP_removePunctuation.m</i>: remove puntuaction  from a string <br>
<i>SNLP_removeShortLines.m</i>: remove short lines from a string <br>
<i>SNLP_removeShortWords.m</i>: remove short words from a string <br>
<i>SNLP_removeSpaces.m</i>: remove all spaces from a string <br>
<i>SNLP_removeStopWords.m</i>: remove a list of words from a string <br>
<i>SNLP_reorderRDM.m</i>: reorder a RDM matrix according to some criteria <br>
<i>SNLP_saveWords.m</i>: save a list of words in a txt file <br>
<i>SNLP_searchWords.m</i>: search a word in a string <br>
<i>SNLP_similarity_encoding.m</i>: perform a machine learning similarity encoding procedure (Anderson et al., 2019; doi:10.1523/JNEUROSCI.2575-18.2019) <br>
<i>SNLP_stemDictionary.m</i>: do the stemming of a dictionary <br>
<i>SNLP_stemming_eng.m</i>: do the stemming of a dictionary for english <br>
<i>SNLP_stemming_ita.m</i>: do the stemming of a dictionary for italian <br>
<i>SNLP_tfidf.m</i>: evaluate from a matrix of occurences the tf-idf (term frequency–inverse document frequency) of words <br>

