require 'tempfile'
require 'shellwords'

module GTD
  module Notes
    class Error < StandardError; end
    class UnknownCommand < Error; end
    class MissingNotesCommand < Error; end

    class CLI
      HELP_TEXT = <<~HELP
        gtd-notes - Apple Notes CLI wrapper (macnotesapp)

        Commands:
          list [--folder FOLDER]  List notes
          cat NOTE                Read note content
          add TEXT                Create a new note
          add --edit              Create note in editor
          edit NOTE               Edit note content
          delete NOTE             Delete a note
          search QUERY            Search notes
          accounts                Show configured accounts
          someday                 List someday/maybe notes (#somedaymaybe)
          reference               List reference notes

        Conventions:
          Reference notes: Title + raw text only
          Someday/Maybe: Must contain #somedaymaybe in text
      HELP

      def initialize(argv)
        @command = argv[0]
        @args = argv[1..]
      end

      def run
        case @command
        when 'list', 'l'
          notes_list
        when 'cat', 'read'
          notes_cat
        when 'add', 'new'
          notes_add
        when 'edit', 'update'
          notes_edit
        when 'delete', 'remove'
          notes_delete
        when 'search', 's'
          notes_search
        when 'accounts'
          notes_accounts
        when 'someday', 'somedaymaybe'
          notes_someday
        when 'reference', 'ref'
          notes_reference
        when 'help', '-h', '--help', nil
          puts HELP_TEXT
          0
        else
          raise UnknownCommand, @command
        end
      end

      private

      def notes_list
        system('notes', 'list', *@args) ? 0 : 1
      end

      def notes_cat
        system('notes', 'cat', *@args) ? 0 : 1
      end

      def notes_add
        system('notes', 'add', *@args) ? 0 : 1
      end

      def notes_edit
        note_name = @args.join(' ')
        Tempfile.create do |temp|
          `notes cat --plaintext #{Shellwords.escape(note_name)} > #{temp.path}`
          system(ENV['EDITOR'] || 'vim', temp.path)

          content = File.read(temp.path)
          lines = content.split("\n")
          title = lines[0] || ''
          body_text = lines[1..].join("\n")
          body_html = body_text.gsub("\n", "</div>\n<div>")
          body_html = "<div>#{body_html}</div>"
          html = "<div><h1>#{title}</h1></div>\n#{body_html}"

          update_note_via_applescript(note_name, title, html)
        end
        0
      end

      def notes_delete
        note_name = @args.join(' ')
        delete_note_via_applescript(note_name)
        0
      end

      def notes_search
        system('notes', 'list', *@args) ? 0 : 1
      end

      def notes_accounts
        system('notes', 'accounts') ? 0 : 1
      end

      def notes_someday
        note_lines = `notes list`.split("\n")
        note_lines.each do |line|
          note_name = line.strip
          next if note_name.empty?

          content = `notes cat #{Shellwords.escape(note_name)} 2>/dev/null`
          puts line if content.include?('#somedaymaybe')
        end
        0
      end

      def notes_reference
        system('notes', 'list', *@args) ? 0 : 1
      end

      def update_note_via_applescript(note_name, title, html)
        script = <<~APPLESCRIPT
          on run argv
            set noteName to item 1 of argv
            set newTitle to item 2 of argv
            set newBody to item 3 of argv
            tell application "Notes"
              set theNote to first note whose name is noteName
              set name of theNote to newTitle
              set body of theNote to newBody
            end tell
          end run
        APPLESCRIPT

        system('osascript', '-e', script, note_name, title, html)
      end

      def delete_note_via_applescript(note_name)
        script = <<~APPLESCRIPT
          on run argv
            set noteName to item 1 of argv
            tell application "Notes"
              delete (first note whose name is noteName)
            end tell
          end run
        APPLESCRIPT

        system('osascript', '-e', script, note_name)
      end
    end
  end
end
