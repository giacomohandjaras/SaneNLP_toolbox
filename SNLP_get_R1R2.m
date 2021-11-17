function [R1,R2]=SNLP_get_R1R2(word_out)
english_vowels='[aeiouy]';
english_consonants='[bcdfghjklmnpqrstvxwz]';
R1='';
R2='';

word_out_mask=zeros(length(word_out),1);
word_out_mask_vowel = regexp(word_out,english_vowels);
word_out_mask(word_out_mask_vowel)=1;
vowels=find(word_out_mask==1);

word_out_mask_consonants = regexp(word_out,english_consonants);
word_out_mask(word_out_mask_consonants)=-1;
consonants=find(word_out_mask==-1);

if(numel(vowels)>0 & numel(consonants)>0)

first_vowel=vowels(1);
first_consonant=find(consonants>first_vowel);
if(numel(first_consonant)>0)
first_consonant=consonants(first_consonant(1));
if(first_consonant<length(word_out))
R1=word_out(first_consonant+1:end);
end
end

if(length(R1)>2)
R1_mask=zeros(length(R1),1);
R1_mask_vowel = regexp(R1,english_vowels);
R1_mask(R1_mask_vowel)=1;
R1_vowels=find(R1_mask==1);
R1_consonants=find(R1_mask==0);
if(numel(R1_vowels)>0 & numel(R1_consonants)>0)
first_R1_vowel=R1_vowels(1);
first_R1_consonant=find(R1_consonants>first_R1_vowel);
if(numel(first_R1_consonant)>0)
first_R1_consonant=R1_consonants(first_R1_consonant(1));
if(first_R1_consonant<length(R1))
R2=R1(first_R1_consonant+1:end);
end
end
end
end

end
end
