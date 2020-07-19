# Création d'un mkdir en ruby : Seul le premier argument d'entrée est pris en compte
# -----------------------------

def check_if_user_gave_input
  abort("mkdir: missing input") if ARGV.empty?
end


def warning_message_if_more_than_one_input
  puts "mkdiruby : les arguments #{ARGV[1..-1].to_s} sont ignorés" if ARGV.size > 1
end


def get_folder_name
  return folder_name = ARGV.first
end


def create_folder(name)
  Dir.mkdir(name)
end


def perform

  check_if_user_gave_input

  warning_message_if_more_than_one_input

  # Récupération du nom de répertoire
  # ---------------------------------
  folder_name = get_folder_name

  # Création du répertoire
  # ----------------------
  create_folder(folder_name)

end

# Only if the file is being executed directly, as a script
if __FILE__ == $0
  perform
end
