module ApplicationHelper
  def logged_in?
    current_user.present?
  end

  def is_admin?
    current_user.try(:admin?)
  end

  def side_header_menu_active (key)
    new_key = params[:controller].split("/")[0] == "websites" ? "website" : params[:controller].split("/")[0]
    key.include?(new_key) ? "color_purple" : ""
  end

  def left_controller
    params[:controller].split("/")[0] == "websites" ? "website" : params[:controller].split("/")[0]
  end

  def sortable(column, title = nil, status_view_demo_tracker = nil, demo_club_type_filter = nil)
    title ||= column.titleize
    if @default_sort.present?
      css_class = column == @default_sort ? "current icon-sort-asc" : "current icon-sort"
      direction = "desc"
    else
      css_class = column == sort_column ? "current icon-sort-#{sort_direction}" : "current icon-sort"
      direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    end
    if !Rails.env.test?
      link_to title, {:sort => column, :direction => direction, :status_view_demo_tracker => status_view_demo_tracker, :demo_club_type_filter => demo_club_type_filter}, {:class => css_class}
    end
  end

  def sortable_remote(column, title = nil, status_view_demo_tracker = nil, demo_club_type_filter = nil)
    title ||= column.titleize
    if @default_sort.present?
      if @default_sort == "orders.internal_id"
        css_class = column == @default_sort.to_s ? "current icon-sort-desc" : "current icon-sort"
        direction = "asc"
      else
        css_class = column == @default_sort.to_s ? "current icon-sort-asc" : "current icon-sort"
        direction = "desc"
      end
    else
      css_class = column == sort_column ? "current icon-sort-#{sort_direction}" : "current icon-sort"
      direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    end
    if !Rails.env.test?
      link_to title, {:sort => column, :direction => direction, :status_view_demo_tracker => status_view_demo_tracker, :demo_club_type_filter => demo_club_type_filter}, {:class => css_class, remote: true}
    end
  end

  def options_for_gender
    [
        ["Feminine", "f"],
        ["Masculine", 'm']
    ]
  end

  def options_for_role
    [
        ["Admin", "admin"],
        ["User", 'employee']
    ]
  end

  def options_for_survey_questions
    [
        ['Free text', 'free_text'],
        ['Multiple choice', 'multiple_choice'],
        ['Multiple answers', 'multiple_answers']
    ]
  end

  def chart_schema_color
    [
        "#B48DF8", "#D32F2F", "#FFE0B2", "#536DFE", "#757575", "#E1BEE7", "#009688", "#4CAF50", "#FFC107", "#CDDC39", \
        "#673AB7", "#00BCD4", "#795548", "#607D8B", "#BDBDBD", "#FF9155", "#FFA58C", "#FFBFBE", "#A56B5D", "#FFBFBE", \
        "#FF8889", '#e6194b', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', '#bcf60c', \
        '#fabebe', '#008080', '#e6beff', '#9a6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075',
    ].uniq.shuffle
  end

  def quotes
    [
        ["Cei mai multi oameni nu se maturizeaza, ci doar cresc. ", "Leo Rosten"],
        ["Daca nu-ti pretuiesti timpul atunci nici altii n-au s-o faca. Nu-ti mai oferi timpul si talentele degeaba. ", "Kim Garst"],
        ["Zambetul: cea mai ieftina si eficienta crema antiriduri. ", "Anonim"],
        ["Nu renunta nicioadata. ", "Winston Churchill"],
        ["Intr-o tara subdezvoltata sa nu beti apa. Intr-o tara superdezvoltata sa nu respirati aerul. ", "Jonathan Raban"],
        ["In viata nu exista limite…Cu exceptia celor autoimpuse. ", "Les Brown"],
        ["Cea mai mare greseala pe care o poti face in viata este sa te temi continuu ca o vei face. ", "Elbert Hubbard"],
        ["E cam greu sa fii eficient, fara sa fi un pic nepoliticos. ", "Elbert Hubbard"],
        ["Nu putem directiona vantul, dar putem ajusta panzele. ", "Autor necunoscut"],
        ["Cand aveam 5 ani, mama mi-a spus ca fericirea este cheia vietii. Cand am mers la la scoala, mi s-a cerut sa scriu ce vreau sa fiu cand voi creste mare. Am scris ca vreau sa fiu fericit. Ei mi-au spus ca nu am inteles sarcina, eu le-am spus ca ei nu au inteles viata. ", "John Lennon"],
        ["Trebuie sa-ti doresti sa fii puternic. Altfel, nu vei ajunge niciodata asa. ", "Friedrich Nietzsche"],
        ["Secretul geniului este transferul spiritului copilariei in maturitate. ", "Thomas Henry Huxley"],
        ["Primul om care a preferat sa injure decat sa dea cu piatra poate fi considerat inventatorul civilizatiei. ", "Sigmund Freud"],
        ["Nu poti impiedica pasaretul de suparari si necazuri sa zboare deasupra ta. Dar sa nu le lasi sa-ti cuibareasca in par, asta poti. ", "Proverb Chinezesc"],
        ["Joaca cinstit, asteapta-te ca altii sa joace murdar si nu-i lasa sa te traga in noroi. ", "Richard Branson"],
        ["In viata nu primesti niciodata ceea ce meriti, ci ceea ce negociezi. ", "Thomas Edison"],
        ["Durerea este inevitabila. Suferinta este optionala. ", "Haruki Murakami"],
        ["Nimic nu valoreaza mai mult decat ziua de azi. ", "Goethe"],
        ["Multi indivizi din societatea moderna sunt ca barcagii: trag la vasle, dar stau cu spatele la viitor. ", "Henry Coanda"],
        ["Necazul cu germanii nu este ca ei trag cu obuze, ci ca le graveaza pe acestea cu citate din Kant. ", "Karl Kraus"],
        ["Te-ai nascut cu aripi, de ce preferti sa te tarasti prin viata? ", "Rumi"],
        ["Posibilitatea ca un vis sa se indeplineasca este cea care face ca viata sa fie interesanta. ", "Paolo Coelho, Alchimistul"],
        ["Peste 20 de ani ai sa regreti mai mult lucrurile pe care nu le-ai facut decat cele pe care le-ai facut. Asa ca ridica ancora, iesi din portul cel sigur si prinde vant in vele. ", "Mark Twain"],
        ["Pot rezuma in doua cuvinte tot ce am invatat despre viata: merge inainte. ", "Robert Frost"],
        ["Cand vezi ca ai aceeasi parere cu majoritatea, este bine sa mai reflectezi o data. ", "Mark Twain"],
        ["Viata este ceva ce faci cand nu te poti duce la culcare. ", "Fran Lebowitz"],
        ["Procrastinarea este arta de a tine pasul cu ziua de ieri. ", "Don Marquis"],
        ["Nu cunoastem decat ceea ce imblanzim. Iar oamenii nu mai au timp sa cunoasca nimic. Cumpara lucruri gata facute de la negustori. Si cum nu exista negustori de prieteni, oamenii nu mai au prieteni. ", "Antoine de Saint Exupery"],
        ["Timpul este moneda vietii tale. Este singura moneda pe care o ai, doar tu poti hotara cum o cheltuiesti. Fi atent ca nu cumva sa lasi alte persoane sa o cheltuiasca in locul tau ! ", "Carl Sandburg"],
        ["Cartile mele sunt ca apa. Cartile marilor genii sunt ca vinul. Din fericire toata lumea bea apa. ", "Mark Twain"],
        ["Mereu ni se pare ca suntem iubiti pentru ca suntem buni si nu realizam ca suntem iubiti pentru ca sunt buni cei care ne iubesc. ", "Lev Tolstoi"],
        ["Oamenii eficienti sunt cei mai mari lenesi, dar sunt niste lenesi inteligenti. ", "David Dunham"],
        ["Pe cer nu exista nicio diferenta intre Est si Vest. Fiecare om isi creeaza propriile diferente si apoi le crede adevarate. ", "Buddha"],
        ["Ei spun intotdeauna ca timpul schimba lucururile, dar de fapt tu esti cel care trebuie sa le schimbe ", "Andy Warhol"],
        ["Faima existentei umane nu consta in a trai, ci in a sti pentru ce traiesti. ", "Leonardo Da Vinci"],
        ["Omul are nevoie de un singur vis pentru a suporta realitatea. ", "Sigmund Freud"],
        ["Nu spune ca nu ai suficient timp. Ai exact acelasi numar de ore intr-o zi cat le-au fost date si lui Helen Keller. Pasteur, Michaelangelo, Maica Tereza, Leonardo da Vinci, Thomas Jefferson si Albert Einstein. ", "H. Jackson Brown Jr."],
        ["Daca iubirea este raspunsul, puteti sa repetati intrebarea? ", "Lily Tomlin"],
        ["Obisnuiam sa lenevesc in pat si sa ma intreb: “Voi fi o vedeta TV? Sau voi tine discursuri motivationale?”. N-a fost o viziune. Dar cum se intampla de obicei, am ingropat asta, gandind: Da, sigur. ", "Jennifer Lawrence"],
        ["Tinem la viata ca la o femeie iubita: pe zi ce trece, ii descoperim tot mai multe scaderi si, totusi, nu ne putem desparti de ea… ", "Lucian Blaga"],
        ["Indiferent ce faci in viata, va fi nesemnificativ. Dar e foarte important sa o faci. ", "Mahatma Gandhi"],
        ["Orice om e prost cel putin cinci minute pe zi; intelepciunea consta in a nu depasi aceasta limita. ", "Elbert Hubbard"],
        ["Nu-mi place de acel om. Trebuie sa-l cunosc mai bine. ", "Abraham Lincoln"],
        ["Fa ceea ce poti, cu ceea ce ai, acolo unde esti. ", "Theodore Roosevelt"],
        ["A fura idei de la cineva, este plagiat. A le fura de la mai multi, este cercetare. ", "Legea lui Murphy"],
        ["Tot ce e bun: ori e imoral, ori este ilegal, ori ingrasa. ", "Legea lui Murphy"],
        ["Nimic nu este mai inutil decat sa faci in mod eficient ceea ce nu ar trebui facut deloc. ", "Anonim"],
        ["Ca si in viata, si in iubire contrariile se atrag, nu se distrug. ", "Ch. Baudelaire"],
        ["Unii oamenii sunta atat de saraci incat singurul lucru pe care il au sunt banii. ", "autor necunoscut"],
        ["Un om care vede lumea la cincizeci de ani la fel cum a vazut-o la douazeci de ani, a pierdut treizeci de ani din viata ! ", "Muhammad Ali"],
        ["Toate visele tale se pot indeplini daca ai curajul sa le urmezi. ", "Walt Disney"],
        ["Nu judeca fiecare zi dupa recolata ce ai recolatat ci dupa semintele pe care le-ai plantat. ", "Robert Louis Stevenson"],
        ["Nimeni nu poate trai fara prieteni, chiar daca stapaneste toate bunurile lumii. ", "Aristotel"],
        ["Sunt recunoscator tuturor celor care mi-au spus NU. Din cauza lor m-am descurcat singur. ", "Albert Einstein"],
        ["Stiu ca sunt prost. Dar cand ma uit in jur prind curaj. ", "Ion Crenga"],
        ["Fa azi ce altii nu fac, ca sa traiesti maine cum altii nu pot. ", "Zig Ziglar"],
        ["Sa faca un pas nou, sa rosteasca un cuvant nou, de asta se tem oamenii cel mai mult. ", "Fyodor Dostoyevsky"],
        ["Nu ne oprim din joaca atunci cand imbatranim ci imbatranim cand incetam sa ne mai jucam. ", "George Bernard Shaw"],
        ["Eficienta este atunci cand faci lucrurile bine, eficacitatea este atunci cand faci lucrurile care sunt bune. ", "Peter Drucker"],
        ["Eu singura nu pot schimba lumea, dar pot arunca o piatra in apa pentru a creea mai multe valuri. ", "Maica Tereza"],
        ["Daca citesti asta… Felicitari, esti in viata. Daca asta nu e ceva ce te face sa zambesti, atunci nu stiu ce este. ", "Chad Sugg"],
        ["Banul este cea mai sigura piatra de incercare a firii omenesti. ", "Vasile Alecsandri"],
        ["Exista doar trei lucruri pe care poti sa le faci pentru o femeie: poti sa o iubesti, sa suferi pentru ea sau sa o transformi in literatura. ", "Henry Miller"],
        ["Partea cea mai nobila a ratiunii este impotriva furiei mele. Ea imi spune ca este lucru mai pretios sa ierti decat sa te razbuni. ", "William Shakespeare"],
        ["Frumusetea incepe in momentul in care decizi sa fii tu insuti. ", "Coco Chanel"],
        ["Nu poti opri valurile, insa poti invata sa navighezi. ", "Jon Kabat Zinn"],
        ["Initial a fost o lume a barbatilor. Apoi, a aparut Eva. ", "Richard Armour"],
        ["Fara deviatii de la norma progresul nu este posibil. ", "Frank Zappa"],
        ["Limpede nu vezi decat cu inima, ochii nu pot sa patrunda in miezul lucrurilor. ", "Antoine de Saint Exupery"],
        ["Orice om are dreptul sa-si riste viata pentru a si-o pastra. ", "Jean-Jacques Rousseau"],
        ["Intoarce-ti fata catre soare si umbrele vor ramane in urma ta. ", "proverb din Noua Zeelanda"],
        ["Atata timp cat nu-ti pasa unde esti, nu te poti rataci. ", "Legile lui Murphy"],
        ["Viata nu este oare de o suta de ori prea scurta, pentru a ne ingadui luxul de a ne plictisi ? ", "Friedrich Nietzsche"],
        ["A merge cu un prieten prin intuneric este mult mai bine decat a merge singur prin lumina. ", "Helen Keller"],
        ["Cand renunt la ceea ce sunt, devin ceea ce as putea fi. ", "Lao Tzu"],
        ["Viata este ca mersul pe bicicleta. Pentru a-ti mentine echilibrul trebuie sa continui sa mergi inainte. ", "Albert Einstein"],
        ["Traieste ca si cum ai muri maine. Invata ca si cum ai trai vesnic. ", "Mahatma Gandhi"],
        ["Nu poti gasi nicaieri poezie, daca n-o ai in tine. ", "Joseph Joubert"],
        ["Ceea ce dau paragrafele scrise cu litere mari este anulat de paragrafele scrise cu litere mici. ", "Legea lui Murphy"],
        ["Omul distinge intre morala lui, ca mod de viata, si morala altuia, ca predica. ", "J. Jaubert"],
        ["Inteligenta e un mijloc de adaptare la mediu al instinctului de conservare. ", "Camil Petrescu"],
        ["Durerea este temporara. Abandonul dureaza o vesnicie. ", "Lance Armstrong"],
        ["Cauta ridicolul in toate lucrurile si il vei gasi. ", "Jules Renard"],
        ["Uitam ca suntem niste particule de praf aruncate prin Univers si ca drumul spre frumos tot in groapa sfarseste. In tot acest mister care se numeste viata, avem o singura certitudine: sufletul. Este singurul pe care merita sa te bazezi. ", "Chris Simion"],
        ["Poti sa traiesti o suta de ani, daca renunti la toate acele lucruri care te fac sa iti doresti sa traiesti atat. ", "Woody Allen"],
        ["Nimeni in afara de noi insine nu ne poate elibera mintile ", "Bob Marley"],
        ["Pentru a atinge culmile succesului trebuie sa te opresti din a-ti cere voie. ", "Autor anonim"],
        ["Trebuie sa stii cum sa accepti un refuz si cum sa refuzi o acceptare. ", "Ray Bradbury"],
        ["Dragostea inseamna sa iubeste ce este greu de iubit. Altfe, nu poate fi numita o virtute. ", "Gilbert Keith Chesterton"],
        ["Viata este o serie de schimbari naturale si spontane. Nu le rezista; asta creeaza numai durere. Lasa realitatea sa fie realitate. Lasa lucrurile sa curga natural inainte in orice fel doresc. ", "Lao Tzu"],
        ["Nimic nu trebuie sa fie inaccesibil sperantelor. Poti spera orice, pentru ca viata insasi e o speranta. ", "Oscar Wilde"],
        ["Cand puterea de iubire va depasi iubirea de putere, in lume va fi pace. ", "Jimi Hendrix"],
        ["Chiar daca un milion de oameni cred intr-o prostie, tot o prostie ramane. ", "Legea lui Murphy"],
        ["Experienta e cel mai dur profesor, pentru ca mai intai iti da testul si apoi iti spune care este lectia. ", "Legea lui Vernon"],
        ["Nu-ti lua mai multe griji in acelasi timp. Sunt unii care fac greseala asta–ei bine, tot ce-au avut si vor avea pe viitor sunt acele griji. ", "Edward Everell Hale"],
        ["Nu te duce acolo unde calea te poate duce, du-te in schimb acolo unde nu este nici o poteca si lasa o urma. ", "Ralph Waldo Emerson"],
        ["Mai bine o dragoste pierduta, decat una neavuta. ", "Mircea Eliade"],
        ["Asta este singurul moment pe care il ai. ", "Osho"],
        ["Nu poti trai o zi perfecta fara sa faci ceva pentru cineva care nu te va putea rasplati niciodata. ", "John Wooden"],
        ["Spune-mi si voi uita, arata-mi si poate imi voi aduce aminte, implica-ma si voi intelege! ", "Confucius"],
        ["Educatia formala iti va asigura existenta. Autoeducatia iti va asigura o avere. ", "Jim Rohn"],
        ["In momentul in care te multumesti cu mai putin decat meriti, vei primi chiar mai putin decat atat. ", "Maureen Dowd"],
        ["Sunt doar doua feluri de oameni pe lume: cei care incearca sa-si umple goliciunea interioara si acele persoane foarte rare si deosebite care incearca sa-si vada aceasta goliciune. ", "Osho"],
        ["Cainilor le vine usor sa-si arate afectiunea. Ei nu se imbufneaza si nu stau suparati. Nu fug niciodata de acasa cand sunt tratati nedrept. Nu se plang niciodata de mancarea ce li se da. Nu se plang de cum arata casa. Sunt cavaleri si curajosi. Gata sa-si protejeze stapana cu pretul vietii lor. Le plac copiii, indiferent de cat de galagiosi si suparatori ei sunt. Cainilor pur si simplu le place sa fie in compania lor. De fapt, cainii fac concurenta sotilor ", "barbatilor si daca acestia ar copia mai mult din virtutile lor, viata in familiile noastre ar fi mult mai placuta. ", "Billy Graham"],
        ["Toate comorile pamantului nu pot cumpara o sansa pierduta. ", "Amanda Scott"],
        ["Casnicia nu ne face nici mai buni, nici mai rai, ci doar intensifica la bine si la rau ceea ce deja se gaseste in noi. ", "Sydney J. Harris"],
        ["Uneori ai succes…iar alteori inveti. ", "Robert Kiyosaki"],
        ["Lucrurile nu se intampla. Lucrurile sunt facute sa se intample. ", "John F. Kennedy"],
        ["Cuvintele sunt precum frunzele. Acolo unde ele abunda, arareori mai gasesti si roade imprejur. ", "Alexander Pope"],
        ["Viata aceasta nu este doar o anticipare a vesniciei, ci adesea este deja si intrare in Imparatie. ", "Sf. Grigore Palama"],
        ["Fa trei preziceri corecte, consecutiv si vei fi considerat un expert. ", "Legea lui Murphy"],
        ["Orice copil are nevoie de un bunic, bunicul oricui, pentru a creste cat mai sigur pe el intr-o lume nefamiliara. ", "Charles si Ann Morse"],
        ["Nu permite ca opiniile celorlalti sa devina realitatea ta. ", "Les Brown"],
        ["Copilaria e cadoul pe care ni-l da viata. ", "Horatiu Malaele"],
        ["Oamenii sunt ca vinurile. Cu timpul, fie devin din ce in ce mai buni, fie se transforma in otet. ", "Papa Ioan Paul al XXIII-lea"],
        ["Suntem doar o rasa avansate de maimute pe o planeta mica a unei stele foarte obisnuite. Dar putem intelege Universul. Asta ne face sa fim speciali. ", "Stephen Hawking"],
        ["Nu incerca sa devi o persoana de succes, ci una de valoare. ", "Albert Einstein"],
        ["Niciodata nu trebuie sa te rusinezi a marturisi ca ai gresit. Inseamna doar sa spui, cu alte cuvinte, ca astazi esti mai intelept decat ieri. ", "Marcel Achard"],
        ["Daca vrei sa dobandesti puterea de a suporta viata, fii gata sa accepti moartea. ", "Sigmund Freud"],
        ["Copiii gasesc totul in nimic, oamenii gasesc nimic in tot. ", "Giacomo Leopardi"],
        ["Cand vezi o persoana buna, gandeste-te cum sa devii ca ea. Cand vezi o persoana nu atat de buna, reflecteaza asupra propriilor puncte slabe. ", "Confucius"],
        ["Viata incepe acolo un frica se termina. ", "Osho"],
        ["Viata este grea. Este mai grea atunci cand esti prost. ", "John Wayne"],
        ["Fara munca, zicea Stendhal, corabia vietii omenesti n-are lest. ", "Stendhal"],
        ["O fapta buna este precum un clopot care cheama oamenii la inchinare. ", "proverb danez"],
        ["Convingerea este de multe ori mai eficienta decat forta. ", "Esop"],
        ["Toata lumea stie ca anumite lucruri sunt irealizabile, pana cand vine cineva care nu stie acest lucru si le realizeaza. ", "Albert Einstein"],
        ["Cuvintele sunt cu adevarat mijlocul de comunicare cel mai putin eficient. Ele sunt cele mai expuse la intrepretari gresite si cel mai adesea prost intelese. ", "Neale Donald Walsch"],
        ["Nimeni nu-mi va darui succesul. Trebuie sa-l castig singur. De aceea sunt aici. Sa domin. Sa cuceresc. Atat lumea cat si pe mine insumi. ", "Autor Necunoscut"],
        ["Ma bucur cand ploua, pentru ca si daca nu m-as bucura, tot ploua. ", "Anonim"],
        ["Viitorul. Perioada aceea in care afacerile noastre prospera, prietenii ne sunt prieteni adevarati si fericirea ne este asigurata. ", "Ambrose Bierce"],
        ["Succesul inseamna sa treci de la un esec la altul fara sa pierzi din entuziasm. ", "Winston Churchill"],
        ["Nimic nu este mai eficient si nimic nu costa mai ieftin ca preventia. ", "Nicolae Opopol"],
        ["Pentru a avea o viata creativa trebuie sa ne depasim frica de a face greseli ", "Autor Anonim"],
        ["Traiesti doar odata, dar daca o faci corect odata este de ajuns. ", "Mae West"],
        ["Prietenia e lucrul cel mai greu de explicat. Nu este ceva ce se poate invata la scoala. Dar daca nu ai invatat ce inseamna prietenia inseamna ca nu ai invatat nimic. ", "Muhammad Ali"],
        ["Orice iti poti imagina este real. ", "Pablo Picasso"],
        ["Nu recunosc alt semn al superioritatii decat bunatatea. ", "Ludwig van Beethoven"],
        ["Multi dintre cei care esueaza o fac pentru ca nu si-au dat seama cat de aproape au fost de succes inainte de a renunta. ", "Thomas Edison"],
        ["Cand statul nu plateste profesorii, copiii sunt cei care vor plati. ", "Guy Bedos"],
        ["Schimbarea nu va veni daca asteptam alta persoana sau asteptam alte timpuri. Noi suntem cei pe care-i asteptam. Noi suntem schimbarea pe care o cautam. ", "Barack Obama"],
        ["Lumea asa cum am creat-o este un proces al gandirii noastre. Nu o putem schimba fara sa ne schimbam gandirea. ", "Albert Einstein"],
        ["Viata e un examen si pentru cuvantatoare si pentru necuvantatoare. ", "R. M. Rilke"],
        ["Cei doi mari inamici ai fericirii sunt durerea si plictiseala. ", "Arthur Schopenhauer"],
        ["Adevarul nu este proprietatea unei singure persoane, ci comoara intregii omeniri. ", "Ralph Waldo Emerson"],
        ["Daca nu-ti convine ceva, schimba acel lucru. Daca nu-l poti schimba, schimba modul in care te gandesti la lucrul respectiv. ", "Mary Engelbreit"],
        ["Glumind putem spune orice, chiar si adevarul. ", "Sigmund Freud"],
        ["Cand suntem copii, teama si recompensa sunt singurele noastre experiente motivationale. ", "Herbert Harris"],
        ["Lenea este mama a noua inventii din zece. ", "Legea lui Murphy"],
        ["Fericirea este ca o minge: alergam duaa ea si cum am prins-o ii dam cu piciorul. ", "Duisseux"],
        ["Daca nu-ti place situatia actuala, atunci fa o schimbare! Nu esti un copac. ", "Jim Rohn"],
        ["In viata puterea este supusa multor cutremure. Atentie la fisuri ! ", "Seneca"],
        ["La inceput noi construim obiceiurile, apoi obiceiurile ne construiesc pe noi. ", "John Dryden"],
        ["Cel care nu-si schimba niciodata opiniile si nu-si corecteaza greselile, nu va deveni niciodata mai intelept. ", "Tryon Edwards"],
        ["Nu cazatura in sine reprezinta esecul…ci faptul ca refuzi sa te ridici. ", "Proverb Chinezesc"],
        ["De fiecare data cand e de facut ceva greu, il deleg celui mai lenes om, pentru ca intotdeauna gaseste o metoda rapida de a face acel lucru. ", "Walter Chrysler"],
        ["Omul care pune o intrebare este prost pentru un moment. Omul care nu intreaba va fi prost toata viata. ", "Confucius"],
        ["Intotdeauna m-a uimit sa cunosc oameni pentru care cartile pur si simplu nu conteaza si oameni care dispretuiesc actul lecturii, daramite pe cel al creatiei. Poate e intotdeauna uimitor sa afli ca dragostea ta nu e la fel de atractiva pentru altii, cum e pentru tine. ", "Salman Rushdie"],
        ["Ce face viata o dulceata e ca se-ntampla o data-n viata! ", "Emily Dickinson"],
        ["In viata nu e o tragedie faptul ca nu-ti atingi scopul. Adevarata tragedie e sa nu ai unul.: ", "Benjamin Mays"],
        ["Un popor fara cultura, este un popor usor de manipulat. ", "Immanuel Kant"],
        ["Daca gasesti un drum fara obstacole, probabil ca drumul acela nu duce nicaieri. ", "J. F. Kennedy"],
        ["Raspandeste lumina, iar intunericul se va risipi de la sine ", "Erasmus"],
        ["Valorezi atat cat te apreciezi. ", "F. Rabelais"],
        ["Nu spune niciodata nu se poate, ci incepe cu sa vedem. ", "Nicolae Iorga"],
        ["In definitiv, nu anii din viata sunt cei care conteaza, ci viata din anii tai. ", "Abraham Lincoln"],
        ["Viata este o tragedie cand este privita in prim-plan si o comedie cand o privesti in plan larg. ", "Charlie Chaplin"],
        ["Niciodata nu esuezi pina nu te opresti din a incerca. ", "Albert Einstein"],
        ["Succesul nu este final, esecul nu este fatal: curajul de a continua este ceea ce conteaza. ", "Winston Churchill"],
        ["Cand toata lumea iti da dreptate, ori esti al naibii de destept, ori esti patron. ", "Andre Birabeau"],
        ["Sunt un succes astazi deoarece am avut un prieten care a crezut in mine si nu m-a lasat inima sa-l dezamagesc. ", "Abraham Lincoln"],
        ["Televizorul este guma de mestecat pentru ochi. ", "Frank Lloyd Wright"],
        ["Atunci cand faci un lucru bine din prima incercare, necazul este ca nimeni nu apreciaza cat de dificil a fost. ", "Legea lui Murphy"],
        ["Limbajul a creat cuvantul singuratate pentru a exprima durerea de a fi singur. Si a creat cuvantul solitudine pentru a exprima bucuria de a fi singur. ", "Paul Tillich"],
        ["Construieste-ti propriile tale visuri sau altcineva te va angaja ca sa le construiesti pe ale sale. ", "Farrah Gray"],
        ["Mi-am distrus toti dusmanii, facandu-i prietenii mei, prin iertare. ", "Abraham Lincoln"],
        ["Sa pari slab atunci cand esti puternic si puternic atunci cand esti slab. ", "Sun Tzu"],
        ["Modul in care ne petrecem zilele este, bineinteles, modul in care ne petrecem vietile. ", "Annie Dillard"],
        ["Sarpele care nu-si poate arunca pielea trebuie sa moara. La fel si mintile care sunt impiedicate sa-si schimbe opiniile inceteaza sa mai fie minti. ", "Friedrich Nietzsche"],
        ["Toti oamenii mari au fost mai intai copii, dar putini dintre ei isi mai aduc aminte. ", "Antonie De Saint-Exupery"],
        ["Vorbele bune pot fi scurte si repede rostite, dar ecoul lor este nesfarsit. ", "Maica Tereza"],
        ["Eu nu sunt ceea ce mi se intampla, eu sunt ceea ce aleg sa devin. ", "Carl Jung"],
        ["Tocmai cand omida credea ca lumea se sfarseste, aceasta s-a transfromat intr-un fluture. ", "Autor anonim"],
        ["Ataseaza-te de cei care te pot face mai bun si primeste-i pe cei care, la randul tau, ii poti face mai buni. ", "Seneca"],
        ["Veselia omului e ca mirosul florilor: ea nu se inalta din sufletele vestede. ", "Nicolae Iorga"],
        ["Nu trebuie sa bantui prin departari caci fericirea se afla intotdeauna la un pas de tine, printre lucrurile pe care le poti atinge doar intinzand mana. ", "Bulwer"],
        ["Mintile extraordinare discuta despre idei marete, mintile obisnuite discuta despre evenimente, mintile mici discuta despre oameni. ", "Eleanor Roosevelt"],
        ["Educatia este cea mai puternica arma ce o putem folosi pentru a schimba lumea. ", "Nelson Mandela"],
        ["Niciodata nu este prea tarziu sa fii ceea ce ai fi putut sa fii. ", "George Eliot"],
        ["Daca fericirea ta depinde de ceva ce face altcineva, atunci chiar ai o problema. ", "Richard Bach"],
        ["Cea mai mare glorie nu o dobandesti atunci cand nu este doborat niciodata, ci atunci cand te ridici dupa ce ai cazut. ", "Confucius"],
        ["Un vapor este in siguranta in port, dar nu prentru asta sunt vapoarele. ", "William G.T. Shedd"],
        ["Nu poti fi invidios si fericit in acelasi timp. ", "Frank Tyger"],
        ["Unele schimbari par negative la suprafata, dar curand vei realiza ca a fost creat spatiu in viata ta astfel incat ceva nou sa apara. ", "Eckhart Tolle"],
        ["Oamenii destepti vorbesc pentru ca au ceva de spus; prostii, pentru ca trebuie sa spuna ceva. ", "Platon"],
        ["Pierdem trei sferturi din noi insine in incercarea de a fi ca alti oameni. ", "Arthur Schopenhauer"],
        ["Progresul nu este provocat de catre cei care se trezesc primii, el este provocat de catre oamenii lenesi care cauta mereu un mod mai usor de a face un lucru. ", "Robert A. Heinlein"],
        ["Cand iertam pe cineva e ca si cum am desface nodul care ne leaga de trecut. ", "Reshad Field"],
        ["Ceea ce nu traim la timp, nu traim niciodata. ", "Octavian Paler"],
        ["Nu te poti indragosti de cineva cu care nu ai ras niciodata. ", "Autor Necunoscut"],
        ["In viata, in general, norocul e rar, in dragoste si mai rar. ", "Epictet"],
        ["Daca ar trebui sa-mi rezum in putine cuvinte experienta mea, as spune ca jocul m-a dus mereu tot mai departe, tot mai adanc in real. Si filozofia mea s-ar reduce la o singura dogma: Joaca-te! ", "Mircea Eliade"],
        ["Vor exista mereu oameni care te vor rani, asa ca trebuie sa-ti pastrezi increderea si doar sa ai mai multa grija in cine ai incredere si a doua oara. ", "Gabriel Garcia Marquez"],
        ["Nu putem schimba viata! Noi putem schimba doar modul in care traim viata. Orice moment este cel mai bun moment si orice loc este cel mai bun loc. ", "Tishan"],
        ["Nimeni nu te poate face sa suferi fara permisiunea ta! ", "Eleanor Roosevelt"],
        ["Viata nu are limite, cu exceptia celor pe care le faci tu. ", "Les Brown"],
        ["Nu mai astepta! Momentul potrivit nu vine niciodata. ", "Napoleon Hill."],
        ["Imposibilul poate fi impartit oricand in posibilitati. ", "Autor necunoscut"],
        ["Adevarata ignoranta nu este absenta cunoasterii, ci refuzul de a o dobandi ", "Karl Popper"],
        ["A avea un prieten este mai vital decat a avea un inger. ", "Nichita Stanescu"],
        ["Ganditi critic si nu memorati doar ceea ce vor altii sa ganditi. ", "N.D. Walsch"],
        ["Daca tu crezi ca esti prea mic sa faci o diferenta, incearca sa dormi in camera cu un tantar. ", "Dalai Lama XIV"],
        ["Sensul vietii este sa ii dai sens. ", "Mircea Eliade"],
        ["In final nu anii din viata ta vor conta, ci viata din anii tai. ", "Abraham Lincoln"],
        ["Continua sa-ti spui ca lucrurile vor merge rau si ai sanse mari sa devii un profet. ", "Isaac Singer"],
        ["In momentul in care ne acceptam limitele noi mergem dincolo de ele. ", "Albert Einstein"]
    ]
  end

end
