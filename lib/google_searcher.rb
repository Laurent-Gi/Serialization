require 'launchy'

# ################################################################################
# L'utilisateur rentre un ARGV à l'exécution du programme
# Si ce dernier ne rentre pas d'ARGV, le programme va lui dire comment ça marche
# L'ARGV correspond à ce que l'utilisateur veut rechercher sur Google
# Le programme va récupérer l'ARGV, contruire une URL à partir de l'ARGV
# Puis le programme va ouvrir un nouvel onglet à partir de cette recherche

# 2.1.1. ARGV
# Commence par créer un programme google_searcher.rb qui va récupérer l'ARGV de l'utilisateur. Si l'ARGV est vide, 
# le programme va s'interrompre et il va dire à l'utilisateur comment s'en servir.

# 2.1.2. Construire l'url
# Si tu vas sur Google, tu peux remarquer que les recherches que tu fais peuvent être entrées en url après
# search?q=ta+recherche. Ainsi, l'URL pour la recherche "How to center a div" sera :
# https://www.google.com/search?q=how+to+center+a+div.

# À partir de ces informations, il sera très aisé pour toi de construire l'URL avec l'ARGV.

# 2.1.3. Ouvrir Google
# Pour ceci, il te faudra utiliser la gem Launchy, et à toi la gloire.
# ################################################################################


def check_user_inputs
  if ARGV.empty? 
    puts("Vous devez rentrer des arguments en entrée :\n")
    abort(" ruby google_searcher.rb that I wan't to find")
  end 
end


def buil_an_url
  # Modèle :"https://www.google.com/search?q=" how+to+center+a+div.

  my_google_url="https://www.google.com/search?q="

  #puts ARGV.each {|str| print str,'+'}
  ARGV.size.times {|i| my_google_url += ARGV[i]+"+"}

  return my_google_url = my_google_url[0..my_google_url.length-2] # Suppression du + final
end


def open_google_search(my_google_url)

  Launchy.open(my_google_url)

end


def perform

  check_user_inputs

  url_to_use = buil_an_url

  open_google_search(url_to_use)

end

# Only if the file is being executed directly, as a script
if __FILE__ == $0
  perform
end