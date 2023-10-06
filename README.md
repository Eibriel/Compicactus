# Compicactus
Compicactus is a game about learning a visual constructed language to chat with a cute AI. Have a date, build memories, share moments and have fun!

- [Wishlist on Steam](https://store.steampowered.com/app/2278200/Compicactus/?utm_source=github&utm_campaign=readme)
- [Devlog on Youtube](https://www.youtube.com/watch?v=hBWV56CIG6o&list=PLoXMxh2dU4JD9KdEFwtnuaq06xZcBSqEM)

## Use of AI
For this game an ontology was used, with a hierarchy of concepts (for example object->person->human), and a database of instances of those objects (for example the Player is a human).

This allowed for some generalizations, for example expecting that all Persons has a favorite color.

This was inspired in the work on [Ontological Semantics](https://mitpress.mit.edu/books/ontological-semantics). The system also uses an utility function to select the answers, given a set of goals, see [Versu](https://if50.substack.com/p/2013-a-family-supper).
