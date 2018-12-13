use SDL2::Raw;
use SDL2::Ext;

enum SNAKEDIR (
  RIGHT => 79,
  LEFT  => 80,
  DOWN  => 81,
  UP    => 82,
);

class SnakeGame::Snake {

  class Piece {

	  has SDL_Rect $.rect is rw;
    has SDL_Color $.color =  SDL_Color.new(:r(255.rand.Int), :g(255.rand.Int), :b(255.rand.Int));
		has Piece    $.next is rw;
		has Piece    $.prev is rw;

	}


  has Piece $.head;
  has Piece $.tail;

  submethod BUILD () {
		my $piece = Piece.new: rect => SDL_Rect.new(:x(400.rand.Int), :y(400.rand.Int), :w(7), :h(7));

    $!head = $piece;
    $!tail = $piece;
		$piece.next = Nil;
		$piece.prev = Nil;
  }

	method move (:$snakedir) {

		loop (my $p = $!tail; $p; $p .= next) {
      $p.rect.x = $p.next.rect.x if $p.next;
      $p.rect.y = $p.next.rect.y if $p.next;
		}

    $!head.rect.x -= 7 if $snakedir ~~ LEFT;
    $!head.rect.x += 7 if $snakedir ~~ RIGHT;
    $!head.rect.y += 7 if $snakedir ~~ DOWN;
    $!head.rect.y -= 7 if $snakedir ~~ UP;
		
	}

	method nom (:$food) {
    
	  my $piece = Piece.new: color => $food.color, rect => $food.rect;

    $!tail.prev = $piece;
		$piece.next = $!tail;
		$piece.prev = Nil;
		$!tail = $piece;
	}
  

	#  method set-color (:$r, :$g, :$b) {
	#  $!color = SDL_Color.new(:$r, :$g, :$b);
	#}

}
