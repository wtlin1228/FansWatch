# frozen_string_literal: true

module FansWatch
  # Executable code for file(s) in bin/ folder
  class Runner
    def self.run!(args)
      page_id = args[0] || ENV['FB_PAGE_ID']
      puts page_id
      unless page_id
        puts 'USAGE: fanswatch [page_id]'
        exit(1)
      end
      page = FansWatch::Page.find(id: page_id)

      output_info(page)
    end

    def self.output_info(page)
      page_name = page.name
      separator = Array.new(page.name.length) { '-' }.join
      page_info =
        page.feed.postings.first(3).map.with_index do |post, index|
          posting_info(post, index)
        end.join

      [page_name, separator, page_info].join("\n")
    end

    def self.posting_info(post, index)
      [
        "#{index + 1}: ",
        message_output(post.message),
        'Attached: ' + attachment_output(post.attachment),
        "\n\n"
      ].join
    end

    def self.message_output(message)
      message ? message : '(blank)'
    end

    def self.attachment_output(attachment)
      attachment ? attachment.url.to_s : '(none)'
    end
  end
end
