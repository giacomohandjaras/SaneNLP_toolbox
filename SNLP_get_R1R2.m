function [R1,R2,RV]=SNLP_get_R1R2(word_in,language)

lang=lower(language);

if(strcmp(lang,'eng'))
language_vowels='[aeiouy]';
language_consonants='[bcdfghjklmnpqrstvxwzY]';
end
if(strcmp(lang,'ita'))
language_vowels='[aeiouàèìòùáéíóú]';
language_consonants='[bcdfghjklmnpqrstvxwz]';
end
if(strcmp(lang,'fra'))
language_vowels='[aeiouyâàëéêèïîôûù]';
language_consonants='[bcçdfghjklmnpqrstvxwzHIUY]';
end


R1='';
R2='';
RV='';

word_in_mask=zeros(length(word_in),1);
word_in_mask_vowel = regexp(word_in,language_vowels);
word_in_mask(word_in_mask_vowel)=1;
vowels=find(word_in_mask==1);

word_in_mask_consonants = regexp(word_in,language_consonants);
word_in_mask(word_in_mask_consonants)=-1;
consonants=find(word_in_mask==-1);

if(numel(vowels)>0 & numel(consonants)>0)

first_vowel=vowels(1);
first_consonant=find(consonants>first_vowel);
if(numel(first_consonant)>0)
first_consonant=consonants(first_consonant(1));
if(first_consonant<length(word_in))
R1=word_in(first_consonant+1:end);
end
end

if(length(R1)>2)
R1_mask=zeros(length(R1),1);
R1_mask_vowel = regexp(R1,language_vowels);
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

if(strcmp(lang,'eng'))
RV='';
end

if(strcmp(lang,'ita') | strcmp(lang,'spa'))
if(word_in_mask(2)==-1)
next_vowel=find(vowels>2);
if(numel(next_vowel)>0 & length(word_in)>(next_vowel(1)+1))
RV=word_in(vowels(next_vowel(1))+1:end);
end
end

if(word_in_mask(1)==1 & word_in_mask(2)==1)
next_consonants=find(consonants>2);
if(numel(next_consonants)>0 & length(word_in)>(next_consonants(1)+1))
RV=word_in(consonants(next_consonants(1))+1:end);
end
end

if(word_in_mask(1)==-1 & word_in_mask(2)==1)
if(length(word_in)>3)
RV=word_in(4:end);
end
end
end %%% end of if(strcmp(lang,'ita'))


if(strcmp(lang,'fra'))
french_exception={'par','col','tap' };

if(word_in_mask(1)==1 & word_in_mask(2)==1)
RV=word_in(4:end);
end
if(vowels(1)>1)
RV=word_in((vowels(1)+1):end);
end
if(word_in_mask(1)==1 & word_in_mask(2)==-1)
if numel(vowels)>1
RV=word_in((vowels(2)+1):end);
end
end

suffix_size=nan(numel(french_exception),1);
for i=1:numel(french_exception)
suffix_pos=regexp(word_in,strcat('^(',french_exception{i},')'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos+length(french_exception{i});
end
end
suffix_pos=find(suffix_size>0);
if numel(suffix_pos)>0
RV=word_in((suffix_size(suffix_pos(1))):end);
end
end %%% end of if(strcmp(lang,'fra'))


end
end
