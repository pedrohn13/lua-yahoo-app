TextView = {x = 0, y = 0, width = 0, height = 0, text = ''}

function TextView:new(x, y, width, height, text)
    textview = {}
    setmetatable(textview, self)
    self.__index = self
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.visible = true
    self.oneline = false
    return self
end

function TextView:padding_bottom() return 3 end

function TextView:padding_left() return 5 end

function TextView:padding_right() return 5 end

function TextView:padding_top() return 3 end

function TextView:draw_oneline()
   if not self.visible then return end

end

function TextView:draw(r, g, b)
    if not self.visible then return end
    if self.oneline then self:draw_oneline() end
	countLine = 1
    --r, g, b, a = canvas:attrColor()
    canvas:attrColor(85, 85, 85, 0)
    canvas:drawRect('fill', self.x, self.y, self.width, self.height)
    canvas:attrColor(255, 255, 255, 0)
    canvas:drawRect('frame', self.x, self.y, self.width, self.height)

    thetext = split(self.text)

    cursor = {
        x = self.x + self:padding_left(),
        y = self.y + self:padding_top()
    }

    space_width, line_height = canvas:measureText(' ')

    i = 1
    while i <= #thetext do
        word_width, word_height = canvas:measureText(thetext[i])

        if self.height - self:padding_top() - self:padding_bottom() <
            word_height then return end

        if cursor.x + word_width < self.x + self.width - self:padding_right() then
            canvas:attrColor(0, 0, 0, 128)
            canvas:drawText(cursor.x + 1, cursor.y + 1, thetext[i])
            canvas:attrColor(r, g, b, 255)
            canvas:drawText(cursor.x, cursor.y, thetext[i])
            cursor.x = cursor.x + word_width + space_width
            i = i + 1
        else
            if cursor.y + 2 * line_height < self.y + self.height - self:padding_bottom() then
                countLine = countLine + 1
                cursor.y = cursor.y + line_height
                cursor.x = self.x + self:padding_left()
            else
                return
            end
        end
    end
    --canvas:attrColor(r, g, b, a)
end

