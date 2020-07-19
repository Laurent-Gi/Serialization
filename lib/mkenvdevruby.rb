# -----------------------------------------------------------------------------
# Création de l'environnement de développement pour les projets en ruby :
# 
#    Seul le premier argument d'entrée est pris en compte
# -----------------------------------------------------------------------------


def  check_the_right_number_of_arguments
  abort("Warning : missing input ! One argument is required (your folder name to create)") if ARGV.empty?
  abort("Too many arguments ! Only one argument is required (your folder name to create)") if ARGV.size > 1
  # puts "=> vous demandez la création d'un répertoire #{ARGV[0]} "
end


def get_folder_name
  return folder_name = ARGV.first
end


def exec_command_system(cmd)
  return system(cmd)
end


def create_folder(name)
  begin
    Dir.mkdir(name)
    puts "=> Création du répertoire #{name}"
    # Intéressant mais je n'ai pas compris où le mettre
    # raise Errno::EEXIST.new("You messed up!")
  rescue Errno::EEXIST => exception
  # A voir https://www.honeybadger.io/blog/a-beginner-s-guide-to-exceptions-in-ruby/
    STDERR.puts "- - - - - -"
    STDERR.puts "Impossible de créer le répertoire #{name}"
    STDERR.puts exception.to_s
    abort("Check your environment before using this advanced tool !")
  end
end


def create_folder_and_jump_in(name)
  
  create_folder(name)

  Dir.chdir("#{name}")
  # puts "Je suis maintenant dans #{Dir.pwd}"
end


def create_std_gemfile(name, gems)

  # Création du fichier
  exec_command_system("touch #{name}")

  # On ouvre le fichier vide juste après sa création "w" ou "a"
  file = File.open(name,"w")
  file.puts("# Way for loading our gems :")
  file.puts("# Fixed ruby version for THP")
  file.puts("# ruby '>= 2.5.1'")
  file.puts("ruby '2.5.1'")
  file.puts("")

  file.puts("source \"https://rubygems.org\" do")
  file.puts("  ")
  file.puts("  # Common gems for THP dans dev")
  file.puts("  gem 'rubocop', '~> 0.88.0', require: false")
  #file.puts("  gem 'pry' \# '~> 0.12.2' ? à confirmer ")

  # Ajout pour tester - mais à faire évoluer pour spécifier les versions !
  gems.each {|str| file.puts("  gem '#{str}'") }

  file.puts("  ")
  file.puts("  # Project gems : add your specific gem for your project")
  file.puts("  ")
  file.puts("end")
  file.close
end

def create_a_complete_gem_environment

  # 1/ Cette commande est en principe déjà active sur nos comptes.
  # exec_command_system("gem install bundler")
  
  # IDEE à développer : ajouter des gem dans un tableau pour qu'il rajoute les require dans les fichiers
  # Tableau des gems utiles au projet et à mettre en require des app.rb
  gem_array=Array.new

  # On initialise avec les gem obligatoires (à ajouter à Gemfile et en require à app.rb)
  gem_array << "pry"
  gem_array << "rspec"
  gem_array << "dotenv"
  # gem_array << "nokogiri"
  # gem_array << "twitter"
  # gem_array << "watir"

  # On interroge pour la suite :
  puts "Voulez-vous ajouter des gems spécifiques (autres que 'pry' 'rspec' 'dotenv' 'rubocop') ?"
  print "> (N/y)"
  local_answer = STDIN.gets.chomp.to_s
  if local_answer == "y"
    puts "Ok, donnez-moi le nom de votre première gem !"  

    gem_name_to_add = STDIN.gets.chomp.to_s

    while gem_name_to_add.size > 0 do
      gem_array << "#{gem_name_to_add}"

      puts "Un autre nom de gem ? ou taper < enter >"  
      gem_name_to_add = STDIN.gets.chomp.to_s
    end

  end

  create_std_gemfile("Gemfile", gem_array)
 
  # Execution de bundle install
  exec_command_system("bundle install")

  return gem_array
end
  # bundel install pour création du Gemfile.lock


def create_a_complete_rspec_environment
  # Création du repertoire spec/ et des fichiers .rspec et Gemfile.lock spec/spec_helper.rb
  puts exec_command_system("rspec --init")  
end


def create_a_complete_rubocop_environment
  exec_command_system("touch .rubocop.yml")
  file = File.open(".rubocop.yml", "w")
  file.puts("inherit_from:")
  file.puts("  - http://relaxed.ruby.style/rubocop.yml")
  file.puts("AllCops:")
  file.puts(" DisplayStyleGuide: true")
  file.puts(" DisplayCopNames: true")
  file.puts(" Exclude:")
  file.puts("  - 'db/schema.rb'")
  file.puts("  - 'vendor/**/*'")
  file.puts("  - 'config/environments/*.rb'")
  file.puts("  - 'bin/*'")
  file.puts("")
  file.puts("#Rails:")
  file.puts("# Enabled: True")
  file.puts("")
  file.puts("Metrics/BlockLength:")
  file.puts(" Exclude:")
  file.puts("  - 'spec/**/*.rb'")
  file.puts("  - 'Guardfile'")
  file.puts("  - 'vendor/bundle'")
  file.close
end


def create_a_complete_git_environment
  # Le .env pour mettre ses clés selon les sites
  exec_command_system("touch .env")
  puts "=> Création du fichier .env"
  # Le .gitignore, pour que le fichier .env ne soit JAMAIS push sur GitHub
  exec_command_system("touch .gitignore")
  file = File.open(".gitignore", "a")
  file.puts(".env")
  file.close
  puts "=> Création du fichier .gitignore et ajout du fichier .env à ignorer dedans"

  # Création du .git via git init
  exec_command_system("git init")
  puts "=> Initialisation de git : avec git init"

end


def create_readme(name)

  exec_command_system("touch #{name}")  

  file = File.open(name, "a")
  file.puts(" Programme développé en Ruby ")
  file.puts(" --------------------------- ")
  file.puts(" ")
  file.puts(" Les gem utiles pour ce programme se trouvent dans le fichier Gemfile")
  file.puts(" ")
  file.puts(" Il suffit d'executer la commande :")
  file.puts(" bundle install")
  file.puts(" ")
  file.puts(" pour que l'environnement soit prêt.")
  file.puts(" ")
  file.puts(" ")
  file.close
end


def create_file_and_spec_files(gems)

  create_folder("lib")

  create_readme("README.md")
  puts "=> Création du fichier README.md\n"


  puts "Voulez-vous créer des fichiers pour vos applications ?"
  puts "Donnez un nom de fichier \"app\" pour création d'un app.rb et app_spec.rb"
  puts "Sinon tapez sur < enter > en laissant le champ vide pour passer l'étape"
  print "> "

  file_name_app = STDIN.gets.chomp.to_s

  while file_name_app.size > 0 do

    puts file_name_app 


    file_name_spec = "spec/" + file_name_app + "_spec.rb"
    file_name_app = "lib/" + file_name_app + ".rb"


    exec_command_system("touch #{file_name_app}")

    file = File.open(file_name_app, "w")
    if gems.empty?
      puts "Warning : pas de \"require 'gem'\" d'ajoutés à vos fichiers app.rb\n"
    else
      gems.each {|str| file.puts("require '#{str}'") }
      # file.puts("require \"pry\"")
      file.puts("")
    end

    file.puts("")
    file.puts("# Only if the file is being executed directly, as a script")
    file.puts("if __FILE__ == $0")
    file.puts("  perform")
    file.puts("end")
    file.close


    exec_command_system("touch #{file_name_spec}")
    # Ajoutons les commandes de require
    file = File.open(file_name_spec, "w")
    file.puts("require_relative ../#{file_name_app}")
    file.puts("")
    file.puts("describe \"Fonction A\" do")
    file.puts("  it \"should do that\" do")
    file.puts("    expect(your_fonction(\"datas\")).to eq({ \"result\" })")
    file.puts("  end")
    file.puts("end")
    file.puts("")
    file.puts("describe \"Fontion B result\" do")
    file.puts("  result = get_...")
    file.puts("  it \"Is not nil\" do")
    file.puts("    expect(result).not_to be_nil")
    file.puts("  end")
    file.puts("  it \"Is an array of more than 10 elements\" do")
    file.puts("    expect((result.is_a? Array) && (result.size > 10)).to be true")
    file.puts("  end")
    file.puts("  it \"Contains string\" do")
    file.puts("    expect(result.all? { |h| h.is_a? String }).to be true")
    file.puts("  end")
    file.puts("end")
    file.close


    puts "Un autre fichier \"app\" pour création d'un app.rb et app_spec.rb ?"
    puts "Tapez sur < Enter > en laissant le champ vide pour passer l'étape"
    print "> "

    file_name_app = STDIN.gets.chomp.to_s
  end # Fin du while...

end

def perform

  check_the_right_number_of_arguments

  create_folder_and_jump_in(get_folder_name)

  # Gem environment :
  # -----------------
  list_of_gem_to_include_as_required = create_a_complete_gem_environment

  # RSPECT environment :
  # --------------------
  create_a_complete_rspec_environment

  # Rubocop simplifié ?
  # -------------------
  create_a_complete_rubocop_environment

  # GIT Environment
  # ---------------
  create_a_complete_git_environment

  # Dev environment :
  # -----------------
  create_file_and_spec_files(list_of_gem_to_include_as_required)

end

# Only if the file is being executed directly, as a script
if __FILE__ == $0
  perform
end