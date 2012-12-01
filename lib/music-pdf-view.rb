require "music-pdf-view/version"
require 'gtk2'
require 'poppler'
require 'uri'
require 'json'

module Music
  module Pdf
    module View
      module Persist
        module_function
        def config_file_for(filename)
          File.join(GLib.user_config_dir, "music-pdf-view", 'margins', URI.escape(filename)+".json")
        end
        def get_margin_for(filename)
          Margin.new(*JSON.parse(File.read(config_file_for(filename))))
        rescue
          Margin.new(30,30,85,35)
        end
        def set_margin_for(filename, margin)
          cfg = config_file_for(filename)
          FileUtils.mkdir_p(File.dirname(cfg))
          File.open(cfg, 'w') { |fp| fp << [margin.top, margin.bottom, margin.left, margin.right].to_json }
        end
      end
      Margin = Struct.new('Margin', :top, :bottom, :left, :right)
      class Renderer
        attr_reader :margin
        def initialize(pdf)
          @pdf = Poppler::Document.new(pdf)
          @margin = Persist.get_margin_for(pdf)
        end
        def draw(cr, max_width, max_height)

          width = @pdf.pages.inject(0) { |c, pg| pg.size[0] + c }
          height = @pdf.pages.map { |pg| pg.size[1] }.max
          wscale = max_width / width.to_f
          hscale = max_height / height.to_f
          wscale = [wscale, hscale].min

          cr.save do
            cr.save do
              cr.scale(wscale, hscale)
              @pdf.pages.each do |pg|
                draw_page(cr, pg)
                cr.translate(pg.size[0],0)
              end
            end
            x = 0
            if false
              cr.set_source_rgb(0.85, 0.85, 0.85)
              cr.set_line_width(1)
              @pdf.pages[0...-1].each_with_index do |pg, i|
                x += pg.size[0]
                cr.move_to((x*wscale).ceil - 0.5, 0)
                cr.line_to((x*wscale).ceil - 0.5, max_height)
                cr.stroke
              end
            end
          end
        end
        def draw_page(cr, page)
          cr.save do
            cr.rectangle(0,0,page.size[0],page.size[1])
            cr.clip
            cr.translate(-margin.left,-margin.top)
            cr.scale(page.size[0] / (page.size[0]-(margin.left + margin.right)),
                     page.size[1] / (page.size[1]-(margin.top + margin.bottom)))
            cr.render_poppler_page(page)
          end
        end

      end
      class Widget < Gtk::DrawingArea
        attr_reader :renderer
        def initialize(pdf)
          super()
          @fn = pdf
          @renderer = Renderer.new(pdf)

          signal_connect(:expose_event, &method(:on_draw))
        end
        def set_margin(what, value)
          @renderer.margin.send("#{what}=", value)
          Persist.set_margin_for(@fn, @renderer.margin)
          queue_draw if visible?
        end

        def on_draw w, evt
          cr = w.window.create_cairo_context
          @renderer.draw(cr, allocation.width, allocation.height)
        end
      end
    end
  end
end
