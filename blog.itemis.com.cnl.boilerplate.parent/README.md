# Xtext and Contrained Natural Languages: Requirement Boilerplates  

There is a wide range of boilerplates used for requirements documentation. For example user stories in agile software development:

	As a <role>, I want <goal/desire> so that <benefit> 

Such boilerplates allow the documentation of requirements in an standardised  way without the knowledge of a specific requirements language and therefore can be used by domain experts as well as requirements engineers. 

Often boilerplates are used with text processing programs which do not provide any input assistance related to the biolerplates for the user and do not allow an automated validation or post-processing of the requirements.    

This post shows how to create a language based on boilerplates using Xtext. The resulting language will allow the usage of natural language in combination with references to model elements at specific parts of the boilerplate. In comprehension to text processing programs the resulting language will support the user through the usability functions of Xtex and will allow the validation of natural language using Part-of-speech tagging (POS-tagging).  

### Boilerplate
The used boilerplate is similar to the one defined by the International Requirements Engineering Board (IREB):  

<center>![boilerplate](file:images/boilerplate.png)</center>  
<center>*Figure 1: The used boilerplate*<sup>[1](#myfootnote1)</sup>.</center>

The following sentences are examples for requirements based on this template. Keywords are bold, references to modell elements are encapsulated in angle brackets and optional parts are in ecapsulated in square brackets:  

- **The** `<printing module>` **shall** `<print>` `<charts>` and `<documents>`.
- [**If** the `<analyst>` created the `<chart>` or `<document>` the] `<printing module>` **shall** **provide** **the** `<analyst>` **with the ability to** `<print>` this `<chart>` or `<document>`.
- **If** the `<charts>` where created by someone else the `<printing module>` **shall** hide the `<print button>`.
- **The** `<printing module>` **will** **provide the** `<client>`**with the ability to** `<print>` `<documents>`.
- [**If** the licence is basic the] `<printing module>` **will provide the** `<client>` **with the ability to** `<print>` `<greyscale documents>`.

### Gramma
The Gramma consists of entities, glossary entries, two types of boilerplates and the rules needed to use natural language.    
	
The Gramma defines the entities *Actor* and *System* which can be referenced in boilerplates by there name:

	Actor: 'Actor'  ':' name=Text 
	description = Description;
	
	System: 'System'  ':' name=Text 
	description = Description;

	Description: 'Description'  ':' text+=SentenceWithReferences*;

The user can use the type *Text* for the name of an entity which can consist of multiple words and is not limited by the Java-ID conventions. Keywords that should be used in Text must be added explicit:

	Text: ( 'To' |  'to' | 'A' | 'a' | 'the' | 'The' | WORD | ANY_OTHER)+;

 To add further informations for an entity the user can create a description for each entity using the type *SentenceWithReferences*. Such a sentence consists of TextWithReferences and a punctuation: 
		
	SentenceWithReferences: text=TextWithReferences punctuation=('.' | '!' | '?');     

*TextWithReferences* allows the combined use of references to entities and plain text. In order to recover the plain text representation of TextWithReferences the rule is defined as follows:   

	TextWithReferences:
		(onlyRefs+=[Entities|STRING]+ | 
		refBefore+=[Entities|STRING]* text+=Text 
		after+=EntitieCombination*
		finalRef+=[Entities|STRING]*);

	EntitieCombination:
		(refs+=[Entities|STRING]+ text+=Text);

References to entities have the type STRING. This allows the referencing of entities with a name consisting of mutliple words. For example the System "printing module".  

The core syntax elements of the language are the Requirement rules. The following rules are the realisation of the boilerplate shown in Figure 1.:   

	Requirement:
		ConditionalRequirement | UnconditionalRequirement;
	
	ConditionalRequirement:
		condition=Precondition system=[System|STRING] liability=Liability end=End;
	
	Precondition:
		conditional=Conditional condition=TextWithReferences;

	enum Liability:
		shall | should | will;

	UnconditionalRequirement:
		the='The' system=[System|STRING] liability=Liability end=End;
	
	ActorInteraction:
		provide='provide' the1='the'? actor=[Actor|STRING] ^with='with' the2='the' ability='ability' to='to';
	
Since an Independent System Activity only consists of a <process> we don't need to create a seperate rule for it. Instead these informations are captured in the attribute objectWithReferences of the Type TextWithGlossaryEntries in the rule *RequirementEnd*:

	RequirementEnd:
		ai=ActorInteraction? objectWithDetails=TextWithGlossaryEntriesOrSynonyms '.';

Such TextWithGlossaryEntriesOrSynonyms has the same structure than TextWithReferences but only *GlossaryEntries* and there synonyms can be referenced. Such a glossary entry can be a *Function* describing a <process> or a *DomainObject*: 

	Glossary:
		{Glossary} 'Glossary' elements+=(GlossaryEntry)*;

	Function:
		'Function' ':' name=Text
		('Synonyms' ':' synonyms+=FunctionSynonym (',' synonyms+=FunctionSynonym)*)?
		('Description' ':' description+=SentenceWithReferences*)?;
	
	DomainObject:
		'Object' ':' name=Text
		('Synonyms' ':' synonyms+=DomainObjectSynonym (',' synonyms+=DomainObjectSynonym)*)?
		('Description' ':' description+=SentenceWithReferences+)?
		('Properties' ':' properties+=Property (',' properties+=Property)*)?;
	
	FunctionSynonym:
		name=Text;
	
	DomainObjectSynonym:
		name=Text; 




### References
<a name="myfootnote1">1</a>:[The IREB boilerplate](https://requirementstechniques.wordpress.com/documentation/requirements-templates/ "IREB Boilerplates")

##Part 2: Natural language validation  

##Part 3: Creating Glossary Entries   


<!--	
Such a boilerplate constrains the structure of a sentence by the definition of keywords and placeholders.  
The most Xtext languages are designed to generate a formal output for example source code in one ore more target languages. This post is not about such languages. Instead I will show you how to create a language for requirements documentation on base of sentence templates (boilerplates). The language will combine keywords, informal natural language (freetext) and references to entities. The resulting language will contrain the use of freetext and therefore can be described as contrained natural language. 
Concrete manifestations of the boileplates are shown in listing 1.

The boilerplate starts with an optional precondition followed by the name of the system under discussion and a liability which can be "must", "should" or "will". The next part can be an user interaction or an independent system activity. An user interaction starts with the keyword "provide" followed by the name of the actor and the keywords "with", "the", "ability" and "to". These keywords are followed by a process term. Such a process term discribing a functionality of the system under discussion. In contrast to an user interaction an independent system activity consists only of such a process term. The next part of the boilerplate is the object which is processed or used. The boilerplate ends with optional details about the object.
-->