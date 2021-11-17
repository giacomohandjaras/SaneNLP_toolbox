function cond=SNLP_isStopWord(word,customStopWords)

cond=0;

if iscell(word)>0
word=word{1};
end

for w=1:numel(customStopWords)
suffix_pos=regexp(word,strcat('^',customStopWords{w},'$'));
if(suffix_pos==1)
cond=1;
break
end
end

end
