function [root_position, word_position, exception]=SNLP_getLongestException(root,word,exceptions)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Get the longest exception for the French stemmer
%%%%
%%%%
%%%%	Sane Natural Language Processing Toolkit, v0.01. https://github.com/giacomohandjaras/SaneNLP_toolbox
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

debug=0;

root_position=[];
word_position=[];
exception='';

if(debug==1); disp(sprintf('Root: %s    Word: %s',root,word));end

root_position_in_the_word=regexp(word,strcat(root,'$'));

exceptions_size=nan(numel(exceptions),1);
for i=1:numel(exceptions)
    suffix_pos=regexp(root,strcat(exceptions{i},'$'));
    if(suffix_pos>0)
        exceptions_size(i)=suffix_pos;
    end
end

[exceptions_min,exceptions_indx]=min(exceptions_size);

if isnan(exceptions_min)==0
    if(debug==1); disp(sprintf('Longest suffix: %s',exceptions{exceptions_indx}));end
    root_position(1)=exceptions_min;
    root_position(2)=root_position(1)+length(exceptions{exceptions_indx})-1;
    word_position(1)=root_position_in_the_word+exceptions_min-1;
    word_position(2)=word_position(1)+length(exceptions{exceptions_indx})-1;
    exception=exceptions{exceptions_indx};
end

end
