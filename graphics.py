import os
os.environ["PYGAME_HIDE_SUPPORT_PROMPT"] = "1"
#silence hello pygame! message
try:
    import pygame
except ModuleNotFoundError:
    pass
import sys

class Screen:
    def __init__(self, columns=40, rows=24, charWidth=16, charHeight=24):
        #set up initial rows/columns
        self.columns = columns
        self.rows = rows
        self.charWidth = charWidth
        self.charHeight = charHeight
        self.running = True
        self.cursorCol = 0
        self.cursorRow = 0
        # Initialize Pygame
        self.pygame = pygame
        self.pygame.init()
        self.pygame.display.init()
        self.screen = self.pygame.display.set_mode(
            (self.columns * self.charWidth, self.rows * self.charHeight), self.pygame.FULLSCREEN
        )
        self.pygame.display.set_caption("apple1py")
        icon = pygame.image.load("assets/icon.png")
        self.pygame.display.set_icon(icon)

        # Font + colors
        self.font = self.pygame.font.Font("assets/font.ttf", self.charHeight)
        self.GREEN = (0, 255, 0)
        self.BLACK = (0, 0, 0)


        # Screen buffer (2D array of characters)
        self.buffer = [[" " for _ in range(self.columns)] for _ in range(self.rows)]
    def write(self, ch):
        """Place a single character at the current cursor and advance cursor."""
        if ch == "\n":  # handle newline
            self.cursorRow += 1
            self.cursorCol = 0
        else:
            self.buffer[self.cursorRow][self.cursorCol] = ch
            self.cursorCol += 1

            # Wrap to next line if end of row reached
            if self.cursorCol >= self.columns:
                self.cursorCol = 0
                self.cursorRow += 1

        # Scroll up if bottom reached
        if self.cursorRow >= self.rows:
            self.buffer.pop(0)  # remove top row
            self.buffer.append([" " for _ in range(self.cols)])  # add empty row
            self.cursor_row = self.rows - 1

        self.drawScreen()

    def drawScreen(self):
        """Redraws the buffer to the display"""
        self.screen.fill(self.BLACK)
        #using our predefined buffer redraws and adds chars
        for r in range(self.rows):
            for c in range(self.columns):
                char = self.buffer[r][c]
                text_surface = self.font.render(char, True, self.GREEN)
                self.screen.blit(text_surface, (c * self.charWidth, r * self.charHeight))
        pygame.display.flip()
    def update(self):
                """Keeps the window open until user closes it."""
                if not self.running: #close if the user closes
                    self.pygame.quit()
                    sys.exit()
                #otherwise event loop
                for event in self.pygame.event.get():
                        if event.type == self.pygame.QUIT:
                              self.running = False
                        elif event.type == self.pygame.KEYUP:
                            if event.key == self.pygame.K_ESCAPE:
                                self.running = False
                                sys.exit()

                      # Draw the screen every frame
                self.drawScreen()
