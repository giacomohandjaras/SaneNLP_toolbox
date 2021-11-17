function [HAS_SHORT_SYL,LAST_SYL_SHORT,SHORT_WORD]=SNLP_is_short_word(word_out,R1);
english_vowels='[aeiouy]';

HAS_SHORT_SYL=0;
LAST_SYL_SHORT=0;
SHORT_WORD=0;

%Mark short syllables and words
word_out_mask_vowel = regexp(word_out,english_vowels);

if(numel(word_out_mask_vowel)>0)
[first_vowel]=min(word_out_mask_vowel);
[last_vowel]=max(word_out_mask_vowel);
if(first_vowel==1)
word_out_mask_vowel(find(word_out_mask_vowel==first_vowel))=[];
end
if(last_vowel==length(word_out))
word_out_mask_vowel(find(word_out_mask_vowel==last_vowel))=[];
end
end


if(numel(word_out_mask_vowel)>0)
short_syllables=zeros(numel(word_out_mask_vowel),1);
for v=1:numel(word_out_mask_vowel)
prev_digit=word_out(word_out_mask_vowel(v)-1);
post_digit=word_out(word_out_mask_vowel(v)+1);
if (isempty(regexp(post_digit,'[wxY]'))==1 & isempty(regexp(post_digit,english_vowels))==1 & isempty(regexp(prev_digit,english_vowels))==1)
short_syllables(v)=1;
end
end
LAST_SYL_SHORT=short_syllables(end);
HAS_SHORT_SYL=max(short_syllables);
else
LAST_SYL_SHORT=1;
HAS_SHORT_SYL=1;
end


if numel(R1)==0 & LAST_SYL_SHORT==1
SHORT_WORD=1;
end


end
