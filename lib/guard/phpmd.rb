require 'guard'

module Guard
	class PHPMD < ::Guard::Plugin

  		VERSION = '0.0.5'

		DEFAULT_OPTIONS = {
            :path => '.',
            :rules => 'pmd-rules.xml',
            :executable => 'phpmd',
	    }

	    def initialize(options = {})
	      defaults = DEFAULT_OPTIONS.clone
	      @options = defaults.merge(options)
	      super(@options)
	    end

	    def run_on_modifications(paths)
			@options[:rules] = File.expand_path @options[:rules]
			paths.each do |path|
				path = File.expand_path path
				Dir.chdir(@options[:path]) do
					results = `#{@options[:executable]} #{path} text #{@options[:rules]}`
					if $?.to_i > 0 then
						::Guard::Notifier.notify(results, :title => 'PHP Mess Detector', :image => :failed)
						puts results
					end
				end
			end
	    end
	end
end
