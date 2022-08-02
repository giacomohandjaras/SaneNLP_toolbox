function word_out_final = SNLP_stemming_eng(word_in)
%%%vers 0.1

debug=0;
english_vowels='[aeiouy]';
english_consonants='[bcdfghjklmnpqrstvxwz]';

english_apostrophe='[''’]';
english_double={'bb','dd','ff','gg','mm','nn','pp','rr','tt'};
english_li={'[cdeghkmnrt]'};

english_suffix_step0={'''','''s','''s'''};
english_suffix_step1a={'sses','ied','ies','s','us','ss'};
english_suffix_step1b={'eed','eedly','ed','edly','ing','ingly'};
english_suffix_step1ba={ 'at', 'bl', 'iz' };
english_suffix_step1c={'y','Y'};
english_suffix_step2={'tional','enci', 'anci', 'abli', 'entli', 'izer', 'ization', 'ational', 'ation', 'ator', 'alism', 'aliti', 'alli', 'fulness', 'ousli', 'ousness', 'iveness', 'iviti', 'biliti', 'bli', 'ogi', 'fulli', 'lessli', 'li' };
english_suffix_step3a={'alize', 'icate', 'iciti', 'ical', 'ful', 'ness' };
english_suffix_step3b={ 'ative' };
english_suffix_step4a={ 'al', 'ance', 'ence', 'er', 'ic', 'able', 'ible', 'ant', 'ement', 'ment', 'ent', 'ism', 'ate', 'iti', 'ous', 'ive', 'ize' };
english_suffix_step4b={ 'sion' , 'tion' };

english_exceptions={'generate', 'generates', 'generated', 'generating', 'general', 'generally', 'generic', 'generically', 'generous', 'generously', 'skis', 'skies', 'dying', 'lying', 'tying', 'idly', 'gently', 'ugly', 'early', 'only', 'singly', 'bristly', 'burly', 'curly', 'surly', 'inning', 'outing', 'canning', 'herring', 'herrings', 'proceed', 'proceeds', 'exceed', 'exceeds', 'succeed', 'succeeds','arsenal','arsenic', 'news', 'howe', 'atlas', 'cosmos', 'bias', 'andes'};
english_exceptions_sub={'generat', 'generat', 'generat', 'generat', 'general', 'general', 'generic', 'generic', 'generous', 'generous', 'ski', 'sky', 'die', 'lie', 'tie', 'idl', 'gentl', 'ugli', 'earli', 'onli', 'singli', 'bristli', 'burli', 'curli', 'surli', 'in', 'out', 'can', 'herring', 'herring', 'proceed', 'proceed', 'exceed', 'exceed', 'succeed', 'succeed','arsenal','arsenic', 'news', 'howe', 'atlas', 'cosmos', 'bias', 'andes'};

word_out=lower(word_in);
%word_out=SNLP_removePunctuation(word_out);
%word_out=SNLP_removeSpaces(word_out);

%0) Return short words.
if length(word_out)<=2
word_out_final=word_out;
return 
end

%0) Return words without at least one consonants and one vowel.
word_out_mask=zeros(length(word_out),1);
word_out_mask_vowel = regexp(word_out,english_vowels);
word_out_mask(word_out_mask_vowel)=1;
vowels=find(word_out_mask==1);

word_out_mask_consonants = regexp(word_out,english_consonants);
word_out_mask(word_out_mask_consonants)=-1;
consonants=find(word_out_mask==-1);

if(numel(vowels)==0 | numel(consonants)==0)
word_out_final=word_out;
return 
end

%SNOWBALL ENG
%%%%%Handle exceptions
for i=1:numel(english_exceptions)
if (strcmp(word_out,english_exceptions{i}))
word_out_final=english_exceptions_sub{i};
return
end
end




%%%%%PRELUDE
%1) Remove initial ', if present.
word_out_mask_apostrophe = regexp(word_out,english_apostrophe);
if(numel(word_out_mask_apostrophe)>0)
if(word_out_mask_apostrophe(1)==1)
word_out=word_out(2:end);
end
end

%2) Set initial y, or y after a vowel, to Y.
word_out_mask_y = regexp(word_out,'y');
if(numel(word_out_mask_y)>0)
if(word_out_mask_y(1)==1)
word_out(1)='Y';
end
end

word_out_mask_vowel = regexp(word_out,english_vowels);
word_out_mask_y = regexp(word_out,'y');
if(numel(word_out_mask_y)>0)
for i=1:numel(word_out_mask_y)
if numel(regexp(word_out(word_out_mask_y(i)-1),english_vowels))>0
word_out(word_out_mask_y(i))='Y';
end
end
end



%%%%%MARK REGIONS
%defining R1, R2 (see the note on R1 and R2) and short ending syllables and short words

R1='';
R2='';
HAS_SHORT_SYL=0;
LAST_SYL_SHORT=0;
SHORT_WORD=0;

[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
[HAS_SHORT_SYL,LAST_SYL_SHORT,SHORT_WORD]=SNLP_is_short_word(word_out,R1);

if(debug==1); disp(sprintf('R1: %s',R1));end
if(debug==1); disp(sprintf('R2: %s',R2));end
if(debug==1); disp(sprintf('HAS_SHORT_SYL: %d',HAS_SHORT_SYL));end
if(debug==1); disp(sprintf('LAST_SYL_SHORT: %d',LAST_SYL_SHORT));end
if(debug==1); disp(sprintf('SHORT_WORD: %d',SHORT_WORD));end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%And now, start the stemming for real!!!
%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP0
%%%%%%%%%%%%%%%%%%%%%%%%
suffix_size=nan(numel(english_suffix_step0),1);
for i=1:numel(english_suffix_step0)
suffix_pos=regexp(word_out,strcat(english_suffix_step0{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step0 più lungo: %s',english_suffix_step0{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(english_suffix_step0{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step0{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step0{suffix_size_min_indx},'$'),'');
end

%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP1A
%%%%%%%%%%%%%%%%%%%%%%%%
suffix_size=nan(numel(english_suffix_step1a),1);
for i=1:numel(english_suffix_step1a)
suffix_pos=regexp(word_out,strcat(english_suffix_step1a{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1a più lungo: %s',english_suffix_step1a{suffix_size_min_indx}));end

if(suffix_size_min_indx==1) %%sses
word_out=regexprep(word_out,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
end

if(suffix_size_min_indx==2 | suffix_size_min_indx==3) %%ied ies
if(suffix_size(suffix_size_min_indx)-1>1)
word_out=regexprep(word_out,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'i');
R1=regexprep(R1,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'i');
R2=regexprep(R2,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'i');
end
if(suffix_size(suffix_size_min_indx)-1<=1)
word_out=regexprep(word_out,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'ie');
R1=regexprep(R1,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'ie');
R2=regexprep(R2,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'ie');
end
end

if(suffix_size_min_indx==4) %%s
word_out_mask_vowel = regexp(word_out,english_vowels);
prev_digit=word_out(suffix_size(suffix_size_min_indx)-1);

if numel(word_out_mask_vowel)>0
if isempty(regexp(prev_digit,english_vowels))==1 & word_out_mask_vowel(1)~=(suffix_size(suffix_size_min_indx)-1) & numel(word_out_mask_vowel)>=1
word_out=regexprep(word_out,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
end

if isempty(regexp(prev_digit,english_vowels))==0 & word_out_mask_vowel(1)~=(suffix_size(suffix_size_min_indx)-1) & numel(word_out_mask_vowel)>1
word_out=regexprep(word_out,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step1a{suffix_size_min_indx},'$'),'');
end
end

end

end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP1B
%%%%%%%%%%%%%%%%%%%%%%%%
suffix_size=nan(numel(english_suffix_step1b),1);
for i=1:numel(english_suffix_step1b)
suffix_pos=regexp(word_out,strcat(english_suffix_step1b{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1b più lungo: %s',english_suffix_step1b{suffix_size_min_indx}));end

if(suffix_size_min_indx==1 | suffix_size_min_indx==2) %%eed   eedly
if isempty(regexp(R1,strcat(english_suffix_step1b{suffix_size_min_indx},'$')))==0
word_out=regexprep(word_out,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'ee');
R1=regexprep(R1,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'ee');
R2=regexprep(R2,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'ee');
end
end

if(suffix_size_min_indx==3 | suffix_size_min_indx==4 | suffix_size_min_indx==5 | suffix_size_min_indx==6 ) %%ed edly ing ingly
word_out_mask_vowel = regexp(word_out,english_vowels);
if numel(word_out_mask_vowel)>1 & word_out_mask_vowel(1)<(suffix_size(suffix_size_min_indx))
word_out=regexprep(word_out,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step1b{suffix_size_min_indx},'$'),'');


%%if the word ends at, bl or iz add e 
suffix_size=nan(numel(english_suffix_step1ba),1);
for i=1:numel(english_suffix_step1ba)
suffix_pos=regexp(word_out,strcat(english_suffix_step1ba{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
word_out=strcat(word_out,'e');
R1=strcat(R1,'e');
R2=strcat(R2,'e');
end

%%if the word ends with a double remove the last letter
suffix_size=nan(numel(english_double),1);
for i=1:numel(english_double)
suffix_pos=regexp(word_out,strcat(english_double{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);
if isnan(suffix_size_min)==0
word_out=word_out(1:end-1);
R1=R1(1:end-1);
R2=R2(1:end-1);
end

%[HAS_SHORT_SYL,LAST_SYL_SHORT,SHORT_WORD]=SNLP_is_short_word(word_out,R1);
if(SHORT_WORD==1)
word_out=strcat(word_out,'e');
R1=strcat(R1,'e');
R2=strcat(R2,'e');
end

end
end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP1C
%%%%%%%%%%%%%%%%%%%%%%%%
suffix_size=nan(numel(english_suffix_step1c),1);
for i=1:numel(english_suffix_step1c)
suffix_pos=regexp(word_out,strcat(english_suffix_step1c{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step1c più lungo: %s',english_suffix_step1c{suffix_size_min_indx}));end
prev_digit=word_out(suffix_size(suffix_size_min_indx)-1);
word_out_mask_vowel = regexp(word_out,english_vowels);

if isempty(regexp(prev_digit,english_vowels))==1 & suffix_size(suffix_size_min_indx)-1>0
word_out=regexprep(word_out,strcat(english_suffix_step1c{suffix_size_min_indx},'$'),'i');
R1=regexprep(R1,strcat(english_suffix_step1c{suffix_size_min_indx},'$'),'i');
R2=regexprep(R2,strcat(english_suffix_step1c{suffix_size_min_indx},'$'),'i');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP2
%%%%%%%%%%%%%%%%%%%%%%%%
[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_size=nan(numel(english_suffix_step2),1);
for i=1:numel(english_suffix_step2)
suffix_pos=regexp(R1,strcat(english_suffix_step2{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step2 più lungo: %s',english_suffix_step2{suffix_size_min_indx}));end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'tional'))
word_out=regexprep(word_out,strcat('tional','$'),'tion');
R1=regexprep(R1,strcat('tional','$'),'tion');
R2=regexprep(R2,strcat('tional','$'),'tion');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'enci'))
word_out=regexprep(word_out,strcat('enci','$'),'ence');
R1=regexprep(R1,strcat('enci','$'),'ence');
R2=regexprep(R2,strcat('enci','$'),'ence');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'anci'))
word_out=regexprep(word_out,strcat('anci','$'),'ance');
R1=regexprep(R1,strcat('anci','$'),'ance');
R2=regexprep(R2,strcat('anci','$'),'ance');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'abli'))
word_out=regexprep(word_out,strcat('abli','$'),'able');
R1=regexprep(R1,strcat('abli','$'),'able');
R2=regexprep(R2,strcat('abli','$'),'able');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'entli'))
word_out=regexprep(word_out,strcat('entli','$'),'ent');
R1=regexprep(R1,strcat('entli','$'),'ent');
R2=regexprep(R2,strcat('entli','$'),'ent');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'izer'))
word_out=regexprep(word_out,strcat('izer','$'),'ize');
R1=regexprep(R1,strcat('izer','$'),'ize');
R2=regexprep(R2,strcat('izer','$'),'ize');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ization'))
word_out=regexprep(word_out,strcat('ization','$'),'ize');
R1=regexprep(R1,strcat('ization','$'),'ize');
R2=regexprep(R2,strcat('ization','$'),'ize');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ational'))
word_out=regexprep(word_out,strcat('ational','$'),'ate');
R1=regexprep(R1,strcat('ational','$'),'ate');
R2=regexprep(R2,strcat('ational','$'),'ate');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ation'))
word_out=regexprep(word_out,strcat('ation','$'),'ate');
R1=regexprep(R1,strcat('ation','$'),'ate');
R2=regexprep(R2,strcat('ation','$'),'ate');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ator'))
word_out=regexprep(word_out,strcat('ator','$'),'ate');
R1=regexprep(R1,strcat('ator','$'),'ate');
R2=regexprep(R2,strcat('ator','$'),'ate');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'alism'))
word_out=regexprep(word_out,strcat('alism','$'),'al');
R1=regexprep(R1,strcat('alism','$'),'al');
R2=regexprep(R2,strcat('alism','$'),'al');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'aliti'))
word_out=regexprep(word_out,strcat('aliti','$'),'al');
R1=regexprep(R1,strcat('aliti','$'),'al');
R2=regexprep(R2,strcat('aliti','$'),'al');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'alli'))
word_out=regexprep(word_out,strcat('alli','$'),'al');
R1=regexprep(R1,strcat('alli','$'),'al');
R2=regexprep(R2,strcat('alli','$'),'al');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'fulness'))
word_out=regexprep(word_out,strcat('fulness','$'),'ful');
R1=regexprep(R1,strcat('fulness','$'),'ful');
R2=regexprep(R2,strcat('fulness','$'),'ful');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ousli'))
word_out=regexprep(word_out,strcat('ousli','$'),'ous');
R1=regexprep(R1,strcat('ousli','$'),'ous');
R2=regexprep(R2,strcat('ousli','$'),'ous');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ousness'))
word_out=regexprep(word_out,strcat('ousness','$'),'ous');
R1=regexprep(R1,strcat('ousness','$'),'ous');
R2=regexprep(R2,strcat('ousness','$'),'ous');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'iveness'))
word_out=regexprep(word_out,strcat('iveness','$'),'ive');
R1=regexprep(R1,strcat('iveness','$'),'ive');
R2=regexprep(R2,strcat('iveness','$'),'ive');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'iviti'))
word_out=regexprep(word_out,strcat('iviti','$'),'ive');
R1=regexprep(R1,strcat('iviti','$'),'ive');
R2=regexprep(R2,strcat('iviti','$'),'ive');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'biliti'))
word_out=regexprep(word_out,strcat('biliti','$'),'ble');
R1=regexprep(R1,strcat('biliti','$'),'ble');
R2=regexprep(R2,strcat('biliti','$'),'ble');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'bli'))
word_out=regexprep(word_out,strcat('bli','$'),'ble');
R1=regexprep(R1,strcat('bli','$'),'ble');
R2=regexprep(R2,strcat('bli','$'),'ble');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'ogi'))
suffix_pos=regexp(word_out,'ogi$');
prev_digit=word_out(suffix_pos-1);
if(strcmp(prev_digit,'l'))
word_out=regexprep(word_out,strcat('ogi','$'),'og');
R1=regexprep(R1,strcat('ogi','$'),'og');
R2=regexprep(R2,strcat('ogi','$'),'og');
end
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'fulli'))
word_out=regexprep(word_out,strcat('fulli','$'),'ful');
R1=regexprep(R1,strcat('fulli','$'),'ful');
R2=regexprep(R2,strcat('fulli','$'),'ful');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'lessli'))
word_out=regexprep(word_out,strcat('lessli','$'),'less');
R1=regexprep(R1,strcat('lessli','$'),'less');
R2=regexprep(R2,strcat('lessli','$'),'less');
end

if(strcmp(english_suffix_step2{suffix_size_min_indx},'li'))
suffix_pos=regexp(word_out,'li$');
prev_digit=word_out(suffix_pos-1);

if isempty(regexp(prev_digit,english_li))==0
word_out=regexprep(word_out,strcat('li','$'),'');
R1=regexprep(R1,strcat('li','$'),'');
R2=regexprep(R2,strcat('li','$'),'');
end

end
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP3
%%%%%%%%%%%%%%%%%%%%%%%%
[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_size=nan(numel(english_suffix_step3a),1);
for i=1:numel(english_suffix_step3a)
suffix_pos=regexp(R1,strcat(english_suffix_step3a{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step3a più lungo: %s',english_suffix_step3a{suffix_size_min_indx}));end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'alize'))
word_out=regexprep(word_out,strcat('alize','$'),'al');
R1=regexprep(R1,strcat('alize','$'),'al');
R2=regexprep(R2,strcat('alize','$'),'al');
end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'icate'))
word_out=regexprep(word_out,strcat('icate','$'),'ic');
R1=regexprep(R1,strcat('icate','$'),'ic');
R2=regexprep(R2,strcat('icate','$'),'ic');
end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'iciti'))
word_out=regexprep(word_out,strcat('iciti','$'),'ic');
R1=regexprep(R1,strcat('iciti','$'),'ic');
R2=regexprep(R2,strcat('iciti','$'),'ic');
end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'ical'))
word_out=regexprep(word_out,strcat('ical','$'),'ic');
R1=regexprep(R1,strcat('ical','$'),'ic');
R2=regexprep(R2,strcat('ical','$'),'ic');
end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'ful'))
word_out=regexprep(word_out,strcat('ful','$'),'');
R1=regexprep(R1,strcat('ful','$'),'');
R2=regexprep(R2,strcat('ful','$'),'');
end

if(strcmp(english_suffix_step3a{suffix_size_min_indx},'ness'))
word_out=regexprep(word_out,strcat('ness','$'),'');
R1=regexprep(R1,strcat('ness','$'),'');
R2=regexprep(R2,strcat('ness','$'),'');
end

end


[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_size=nan(numel(english_suffix_step3b),1);
for i=1:numel(english_suffix_step3b)
suffix_pos=regexp(R2,strcat(english_suffix_step3b{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step3b più lungo: %s',english_suffix_step3b{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat('ative','$'),'');
R1=regexprep(R1,strcat('ative','$'),'');
R2=regexprep(R2,strcat('ative','$'),'');
end



%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP4
%%%%%%%%%%%%%%%%%%%%%%%%
[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_size=nan(numel(english_suffix_step4a),1);
for i=1:numel(english_suffix_step4a)
suffix_pos=regexp(R2,strcat(english_suffix_step4a{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step4a più lungo: %s',english_suffix_step4a{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat(english_suffix_step4a{suffix_size_min_indx},'$'),'');
R1=regexprep(R1,strcat(english_suffix_step4a{suffix_size_min_indx},'$'),'');
R2=regexprep(R2,strcat(english_suffix_step4a{suffix_size_min_indx},'$'),'');
end

[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_size=nan(numel(english_suffix_step4b),1);
for i=1:numel(english_suffix_step4b)
suffix_pos=regexp(R2,strcat(english_suffix_step4b{i},'$'));
if(suffix_pos>0)
suffix_size(i)=suffix_pos;
end
end
[suffix_size_min,suffix_size_min_indx]=min(suffix_size);

if isnan(suffix_size_min)==0
if(debug==1); disp(sprintf('Suffisso step4b più lungo: %s',english_suffix_step4b{suffix_size_min_indx}));end
word_out=regexprep(word_out,strcat('ion','$'),'');
R1=regexprep(R1,strcat('ion','$'),'');
R2=regexprep(R2,strcat('ion','$'),'');
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%STEP5
%%%%%%%%%%%%%%%%%%%%%%%%
%[HAS_SHORT_SYL,LAST_SYL_SHORT,SHORT_WORD]=SNLP_is_short_word(word_out,R1);

[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_pos=regexp(R2,strcat('e','$'));
if(suffix_pos>0)
word_out=regexprep(word_out,strcat('e','$'),'');
R1=regexprep(R1,strcat('e','$'),'');
R2=regexprep(R2,strcat('e','$'),'');
else
suffix_pos=regexp(R1,strcat('e','$'));
if(suffix_pos>0) & (LAST_SYL_SHORT==0)
word_out=regexprep(word_out,strcat('e','$'),'');
R1=regexprep(R1,strcat('e','$'),'');
R2=regexprep(R2,strcat('e','$'),'');
end
end


[R1, R2, ~]=SNLP_get_R1R2(word_out,'eng');
suffix_pos=regexp(word_out,strcat('ll','$'));
if(suffix_pos>0)
suffix_pos=regexp(R2,strcat('l','$'));
if(suffix_pos>0)
word_out=regexprep(word_out,strcat('l','$'),'');
R1=regexprep(R1,strcat('l','$'),'');
R2=regexprep(R2,strcat('l','$'),'');
end
end

word_out = regexprep(word_out,'Y','y');
word_out_final=word_out;
end
