use SDL2::Raw;
use SDL2::Ext;

  enum SNAKEDIR (
    RIGHT => 79,
    LEFT  => 80,
    DOWN  => 81,
    UP    => 82,
	);

class SnakeGame::Snake {

  has SDL_Color $.color;
  has SDL_Rect $!head;
  has $!body;

  submethod BUILD (
	  :$!color;
		) {

    $!head = SDL_Rect.new(:x(400.rand.Int), :y(400.rand.Int), :w(14), :h(14));
		$!body = SDL_Rect => $!head;
  }

	method go (:$direction) {
			$!body.x = $!head.x -7 if $direction ~~ LEFT;
	}
  

  method set-color (:$r, :$g, :$b) {
    $!color = SDL_Color.new(:$r, :$g, :$b);
	}

  method grow (:$amount) {
    $!head.grow(:$amount);
	}
}
