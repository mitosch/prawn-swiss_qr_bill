# frozen_string_literal: true

module Prawn
  module SwissQRBill
    # Draws a box with corner ticks
    class CornerBox
      TICK_SIZE = 3.mm

      LINE_WIDTH = 0.75

      def initialize(document, point, options)
        unless options.key?(:width) && options.key?(:height)
          raise ArgumentError,
                'corner_box needs the :width and :height option to be set'
        end

        @document = document
        @point = point
        @width = options[:width]
        @height = options[:height]

        @brain = {}
      end

      def draw
        set_styles
        draw_lines
        reset_styles
      end

      private

      def set_styles
        @document.line_width = LINE_WIDTH
        @brain[:line_width] = @document.line_width
      end

      def reset_styles
        @document.line_width = @brain[:line_width]
      end

      def draw_lines
        point_x, point_y = @point

        @document.stroke do
          draw_horizontal_lines(point_x, point_y)
          draw_vertical_lines(point_x, point_y)
        end
      end

      def draw_horizontal_lines(point_x, point_y)
        # upper lines
        @document.horizontal_line point_x, point_x + TICK_SIZE,
                                  at: point_y
        @document.horizontal_line point_x + @width, point_x + @width - TICK_SIZE,
                                  at: point_y
        # lower lines
        @document.horizontal_line point_x, point_x + TICK_SIZE,
                                  at: point_y - @height
        @document.horizontal_line point_x + @width, point_x + @width - TICK_SIZE,
                                  at: point_y - @height
      end

      def draw_vertical_lines(point_x, point_y)
        # upper lines
        @document.vertical_line point_y, point_y - TICK_SIZE,
                                at: point_x
        @document.vertical_line point_y, point_y - TICK_SIZE,
                                at: point_x + @width

        # lower lines
        @document.vertical_line point_y - @height, point_y - @height + TICK_SIZE,
                                at: point_x
        @document.vertical_line point_y - @height, point_y - @height + TICK_SIZE,
                                at: point_x + @width
      end
    end
  end
end
