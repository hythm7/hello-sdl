use SDL2::Raw;
use SDL2::Ext;

class SnakeGame::Snake {

  has SDL_Color $.color;

  has SDL_Rect $.head;
  has SDL_Rect $.tail;
  has SDL_Rect @.body;

  submethod BUILD (
	  :$!color;
		) {

    $!head = SDL_Rect.new(:x(400.rand.Int), :y(400.rand.Int), :w(14), :h(14));
  }

	method update-head (:$x, :$y) {
    $!head.x += $x;
    $!head.y += $y;

	}
  

  method set-color (:$r, :$g, :$b) {
    $!color = SDL_Color.new(:$r, :$g, :$b);
	}

  method grow (:$amount) {
    $!head.grow(:$amount);
	}
}
