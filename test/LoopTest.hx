package;

import massive.munit.Assert;
using Detox;
import dtx.widget.Loop;

class LoopTest 
{
	public function new() 
	{
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
		// trace ("BeforeClass");
	}
	
	@AfterClass
	public function afterClass():Void
	{
		// trace ("AfterClass");
	}
	
	@Before
	public function setup():Void
	{
		// trace ("Setup");
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	@Test 
	public function createEmptyLoop():Void
	{
		var l = new Loop();
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
		Assert.areEqual("<!-- Detox Loop -->", l.html());
	}

	@Test 
	public function numItems():Void
	{
		var l = new Loop();
		Assert.areEqual(0, l.numItems);

		l.setList('A,B,C,D'.split(','));
		Assert.areEqual(4, l.numItems);

		l.addList('E,F'.split(','));
		Assert.areEqual(6, l.numItems);

		l.setList('A,B'.split(','));
		Assert.areEqual(2, l.numItems);

		l.addItem('C');
		Assert.areEqual(3, l.numItems);

		l.removeItem('B');
		Assert.areEqual(2, l.numItems);

		l.empty();
		Assert.areEqual(0, l.numItems);
	}

	@Test 
	public function preventDuplicatesTrue():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;

		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(5, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(6, l.numItems);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
	}

	@Test 
	public function preventDuplicatesFalse():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = false;
		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(7, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(11, l.numItems);

		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());
	}

	@Test 
	public function preventDuplicatesNull():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = null;
		Assert.areEqual(false, l.preventDuplicates);
	}

	@Test 
	public function preventDuplicatesDefault():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D,B,C,E'.split(','));
		Assert.areEqual(7, l.numItems);

		l.addList('A,B,E,F'.split(','));
		Assert.areEqual(11, l.numItems);

		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());
		Assert.areEqual(false, l.preventDuplicates);
	}

	@Test 
	public function preventDuplicatesChangeToTrueWithExistingItems():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D,B,C,E'.split(','));
		l.addList('A,B,E,F'.split(','));

		Assert.areEqual(false, l.preventDuplicates);
		Assert.areEqual(11, l.numItems);
		Assert.areEqual(" Detox Loop ABCDBCEABEF", l.text());

		l.preventDuplicates = true;

		Assert.areEqual(true, l.preventDuplicates);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
		Assert.areEqual(6, l.numItems);
	}

	@Test
	public function addItem():Void
	{
		var l = new Loop<String>();

		l.addItem("1");
		Assert.areEqual(1, l.numItems);
		Assert.areEqual(2, l.length);
		Assert.areEqual("<!-- Detox Loop -->1", l.html());

		l.addItem("2");
		Assert.areEqual(2, l.numItems);
		Assert.areEqual(3, l.length);
		Assert.areEqual("<!-- Detox Loop -->12", l.html());
	}

	@Test 
	public function addItemNull():Void
	{
		var l = new Loop<String>();
		l.addItem(null);
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
		Assert.areEqual("<!-- Detox Loop -->", l.html());
	}

	@Test 
	public function generateItem():Void
	{
		var l = new Loop<String>();
		var i1 = l.generateItem("123");
		var i2 = l.generateItem("Hello <em>Kind</em> World...");

		Assert.areEqual("123", i1.input);
		Assert.areEqual("123", i1.dom.html());
		Assert.isTrue(i1.dom.getNode().isTextNode());

		Assert.areEqual("Hello <em>Kind</em> World...", i2.input);
		Assert.areEqual("Hello <em>Kind</em> World...", i2.dom.html());
		Assert.areEqual("Hello Kind World...", i2.dom.text());
		Assert.isTrue(i2.dom.getNode(0).isTextNode());
		Assert.isTrue(i2.dom.getNode(1).isElement());
		Assert.areEqual("em", i2.dom.getNode(1).tagName());
		Assert.isTrue(i2.dom.getNode(2).isTextNode());
	}

	@Test 
	public function generateItemNull():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem(null);

		Assert.areEqual(null, i.input);
		Assert.areEqual("null", i.dom.html());
	}

	@Test 
	public function insertItemDefault():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemStart():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 0);

		Assert.areEqual(" Detox Loop 1ABCD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemMiddle():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 3);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemEnd():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i = l.generateItem("1");
		l.insertItem(i, 4);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function insertItemOutOfRange():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		var i1 = l.generateItem("1");
		var i2 = l.generateItem("2");
		l.insertItem(i1, -99);
		l.insertItem(i2, 99);

		Assert.areEqual(" Detox Loop ABCD12", l.text());
		Assert.areEqual(6, l.numItems);
	}

	@Test 
	public function empty():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(5, l.length);
		
		l.empty();

		Assert.areEqual(" Detox Loop ", l.text());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
	}

	@Test 
	public function emptyWhenAlreadyEmpty():Void
	{
		var l = new Loop<String>();
		l.empty();

		Assert.areEqual(" Detox Loop ", l.text());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);
	}

	@Test 
	public function emptyWhenRandomStuffInserted():Void
	{
		var l = new Loop<String>();
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(1, l.length);

		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(5, l.length);

		var n = "<!-- New Comment -->".parse().getNode();
		l.add(n);
		Assert.areEqual(4, l.numItems);
		Assert.areEqual(6, l.length);
		
		l.empty();

		Assert.areEqual("<!-- Detox Loop --><!-- New Comment -->", l.html());
		Assert.areEqual(0, l.numItems);
		Assert.areEqual(2, l.length);
	}

	@Test 
	public function setList():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList('E,F'.split(','));

		Assert.areEqual(2, l.numItems);
		Assert.areEqual(" Detox Loop EF", l.text());
	}

	@Test 
	public function setListEmpty():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList([]);

		Assert.areEqual(0, l.numItems);
		Assert.areEqual(" Detox Loop ", l.text());
	}

	@Test 
	public function setListNull():Void
	{
		var l = new Loop<String>();
		l.setList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.setList(null);

		Assert.areEqual(0, l.numItems);
		Assert.areEqual(" Detox Loop ", l.text());
	}

	@Test 
	public function addList():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList('E,F'.split(','));

		Assert.areEqual(6, l.numItems);
		Assert.areEqual(" Detox Loop ABCDEF", l.text());
	}

	@Test 
	public function addListEmpty():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList([]);

		Assert.areEqual(4, l.numItems);
		Assert.areEqual(" Detox Loop ABCD", l.text());
	}

	@Test 
	public function addListNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(4, l.numItems);

		l.addList(null);

		Assert.areEqual(4, l.numItems);
		Assert.areEqual(" Detox Loop ABCD", l.text());
	}

	@Test 
	public function removeItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.removeItem(i);

		Assert.areEqual(" Detox Loop ABCDFGH", l.text());
		Assert.areEqual(7, l.numItems);
	}

	@Test 
	public function removeItemByValue():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		l.removeItem('C');

		Assert.areEqual(" Detox Loop ABD", l.text());
		Assert.areEqual(3, l.numItems);
	}

	@Test 
	public function removeItemNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));

		l.removeItem(null);

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function removeItemNotInList():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));

		l.removeItem(i);

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function removeItemInListButNotInDOMOrCollection():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D,E,F'.split(','));

		var e = l.getNode(5);
		var f = l.getNode(6);

		e.removeFromDOM();
		l.collection.remove(f);

		l.removeItem('E');
		l.removeItem('F');

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function changeItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(i, "z");

		Assert.areEqual(" Detox Loop ABCDzFGH", l.text());
		Assert.areEqual(8, l.numItems);
	}

	@Test 
	public function changeItemNullItem():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(null, "z");

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);
	}

	@Test 
	public function changeItemNullInput():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));
		l.insertItem(i, 4);
		l.addList('F,G,H'.split(','));

		Assert.areEqual(" Detox Loop ABCDeFGH", l.text());
		Assert.areEqual(8, l.numItems);

		l.changeItem(i, null);

		Assert.areEqual(" Detox Loop ABCDFGH", l.text());
		Assert.areEqual(7, l.numItems);
	}

	@Test 
	public function changeItemNotFound():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem("e");
		l.addList('A,B,C,D'.split(','));

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);

		l.changeItem(i, "z");

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function changeItemDuplicateExists():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));
		var i = l.findItem("C");

		Assert.areEqual(" Detox Loop ABCD", l.text());
		Assert.areEqual(4, l.numItems);

		l.changeItem(i, "A");

		Assert.areEqual(" Detox Loop ABD", l.text());
		Assert.areEqual(3, l.numItems);
	}

	@Test 
	public function moveItemForward():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));

		// Place '1' after 'C'
		var i = l.findItem("1");
		l.moveItem(i, 4);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemBackward():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,1,D'.split(','));

		// Place '1' after 'A'
		var i = l.findItem("1");
		l.moveItem(i, 1);

		Assert.areEqual(" Detox Loop A1BCD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemSameLocation():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Move '1' to after 'B', where it already was
		var i = l.findItem("1");
		l.moveItem(i, 2);

		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemNullPos():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Move '1' to a position of null, should move it to the end
		var i = l.findItem("1");
		l.moveItem(i);

		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemNullItem():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,1,C,D'.split(','));

		// Attempt to move item 'null', nothing should change
		var i = l.findItem("1");
		l.moveItem(null, 0);

		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemItemNotFound():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));

		// Attempt to move item that is not in list, it should be inserted
		var i = l.generateItem("1");
		l.moveItem(i, 3);

		Assert.areEqual(" Detox Loop ABC1D", l.text());
		Assert.areEqual(5, l.numItems);
	}

	@Test 
	public function moveItemPositionOutOfRange():Void
	{
		var l = new Loop<String>();
		l.preventDuplicates = true;
		l.addList('A,B,C,D'.split(','));

		// Move '1' to a position of null, should move it to the end
		var a = l.findItem("A");
		var b = l.findItem("B");
		l.moveItem(a, -100);
		l.moveItem(b, 100);

		Assert.areEqual(" Detox Loop CDAB", l.text());
		Assert.areEqual(4, l.numItems);
	}

	@Test 
	public function moveItemWasAlreadyMovedOnDOM():Void
	{
		var div = "div".create();

		var l = new Loop<String>();
		l.appendTo(div);
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());

		// On the DOM, move the 1 to the end
		var i = l.findItem("1");
		i.dom.insertThisAfter(l.last());
		Assert.areEqual("<!-- Detox Loop -->ABCD1", div.innerHTML());

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
	}

	@Test 
	public function moveItemItemWasRemovedOnDOM():Void
	{
		var div = "div".create();

		var l = new Loop<String>();
		l.appendTo(div);
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());

		// On the DOM, remove the one
		var i = l.findItem("1");
		i.dom.removeFromDOM();
		Assert.areEqual("<!-- Detox Loop -->ABCD", div.innerHTML());

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
	}

	@Test 
	public function getItemPos():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		
		var i = l.generateItem('1');
		l.insertItem(i, 2);
		Assert.areEqual(" Detox Loop AB1CD", l.text());
		Assert.areEqual(2, l.getItemPos(i));

		l.moveItem(i);
		Assert.areEqual(" Detox Loop ABCD1", l.text());
		Assert.areEqual(4, l.getItemPos(i));
	}

	@Test 
	public function getItemPosNull():Void
	{
		var l = new Loop<String>();
		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(-1, l.getItemPos(null));
	}

	@Test 
	public function getItemPosNotInList():Void
	{
		var l = new Loop<String>();
		var i = l.generateItem('1');
		l.addList('A,B,C,D'.split(','));
		Assert.areEqual(-1, l.getItemPos(i));
	}

	@Test 
	public function getItemPosItemMovedInDOM():Void
	{
		var div = "div".create();
		var l = new Loop<String>();
		l.appendTo(div);
		l.preventDuplicates = true;
		l.addList('A,1,B,C,D'.split(','));
		var i = l.findItem("1");

		// Test starting position
		Assert.areEqual("<!-- Detox Loop -->A1BCD", div.innerHTML());
		Assert.areEqual(1, l.getItemPos(i));

		// On the DOM, move the 1 to the end
		i.dom.insertThisAfter(l.last());
		Assert.areEqual("<!-- Detox Loop -->ABCD1", div.innerHTML());
		Assert.areEqual(1, l.getItemPos(i));

		// In the Loop, place '1' at the beginning
		l.moveItem(i, 0);
		Assert.areEqual("<!-- Detox Loop -->1ABCD", div.innerHTML());
		Assert.areEqual(0, l.getItemPos(i));
	}

	@Test 
	public function findItemValue():Void
	{
	}

	@Test 
	public function findItemDom():Void
	{
	}

	@Test 
	public function findItemNull():Void
	{
	}

	@Test 
	public function findItemBoth():Void
	{
	}

	@Test 
	public function findItemNotInList():Void
	{
	}

	@Test 
	public function insertLoopIntoDOM():Void
	{
	}

	@Test 
	public function removeLoopFromDOM():Void
	{
	}

	@Test 
	public function removeLoopAndReattach():Void
	{
	}
}