package part3;

import java.util.ListIterator;
import java.util.NoSuchElementException;

public class LinkedListDouble<T> {

	/**
	 * this class keeps track of each element information
	 * credit : http://www.java2novice.com/data-structures-in-java/linked-list/doubly-linked-list/
	 * @author Lior 
	 *
	 */
	private class NodeDouble {
		T element;
		NodeDouble next;
		NodeDouble prev;

		public NodeDouble(T element, NodeDouble next, NodeDouble prev) {
			this.element = element;
			this.next = next;
			this.prev = prev;
		}

		public String toString() {
			return "" + element;
		}

	}

	private NodeDouble head;
	private NodeDouble tail;
	private int size;

	public LinkedListDouble() {
		size = 0;
	}

	/**
	 * returns the size of the linked list
	 * @return int 
	 */
	public int size() { return size; }

	/**
	 * return whether the list is empty or not
	 * @return - true \ false if emty or not.
	 */
	public boolean isEmpty() { return size == 0; }

	/**
	 * adds element at the starting of the linked list
	 * @param element - element.
	 */
	public void addFirst(T element) {
		NodeDouble tmp = new NodeDouble(element, head, null);
		if(head != null ) {head.prev = tmp;}
		head = tmp;
		if(tail == null) { tail = tmp;}
		size++;
		//System.out.println("adding: "+element);
	}

	/**
	 * adds element at the end of the linked list
	 * @param element - element.
	 */
	public void add(T element) {

		NodeDouble tmp = new NodeDouble(element, null, tail);
		if(tail != null) {tail.next = tmp;}
		tail = tmp;
		if(head == null) { head = tmp;}
		size++;
		//System.out.println("adding: "+element);
	}

	/**
	 * this method removes element from the start of the linked list
	 * @return element
	 */
	public T removeFirst() {
		if (size == 0) throw new NoSuchElementException();
		NodeDouble tmp = head;
		head = head.next;
		head.prev = null;
		size--;
		//System.out.println("deleted: "+tmp.element);
		return tmp.element;
	}

	/**
	 * this method removes element from the end of the linked list
	 * @return element
	 */
	public T removeLast() {
		if (size == 0) throw new NoSuchElementException();
		NodeDouble tmp = tail;
		tail = tail.prev;
		tail.next = null;
		size--;
		//System.out.println("deleted: "+tmp.element);
		return tmp.element;
	}

	/**
	 * this function returns list iterator.
	 * @return ListIterator
	 */
	public ListIterator<NodeDouble> listIterator() {

		return new ListIterator<>() {

			NodeDouble current = head;

			@Override
			public boolean hasNext() {
				return current != null;
			}

			@Override
			public NodeDouble next() {
				if(hasNext()){
					NodeDouble tmp = current;
					current = current.next;
					return tmp;
				}
				return null;
			}

			@Override
			public boolean hasPrevious() {
				return current.prev != null;
			}

			@Override
			public NodeDouble previous() {
				if(hasPrevious()){
					current = current.prev;
					return current;
				}
				return null;
			}

			@Override
			public int nextIndex() {
				throw new UnsupportedOperationException();
			}

			@Override
			public int previousIndex() {
				throw new UnsupportedOperationException();
			}

			@Override
			public void remove() {
				throw new UnsupportedOperationException();					
			}

			@Override
			public void set(NodeDouble e) {
				throw new UnsupportedOperationException();					
			}

			@Override
			public void add(NodeDouble e) {
				throw new UnsupportedOperationException();					
			}
		};
	}

	/**
	 * This function represents the list in direct and reverse walk.
	 */
	public String toString() {
		String direct_walk = "";
		String reverse_walk = "";
		ListIterator<NodeDouble> direct_itr = this.listIterator();
		ListIterator<NodeDouble> reverse_itr = this.listIterator();
		while(direct_itr.hasNext()) {
			direct_walk += direct_itr.next().element + ",";
		}
		while(reverse_itr.hasNext()) {
			reverse_walk = reverse_itr.next().element + "," + reverse_walk;
		}
		return "direct walk:" + System.lineSeparator() + direct_walk + System.lineSeparator()
		+ "reverse walk:" + System.lineSeparator() + reverse_walk;
	}

	public static void main(String a[]){
		LinkedListDouble<Character> lld = new LinkedListDouble<Character>();
		lld.add('a');
		lld.add('b');
		lld.add('c');
		lld.add('d');
		lld.add('e');
		System.out.println(lld);
	}
}
