public class Supermarkt {
	
	private int anzahlRegale;
	private int maxKunden;
	private int anzahlKunden;
	private boolean[] regalBesetzt;
	private int anzahlWartendeAnKasse;
	private int[] warteschlangeKasse;
	
	public Supermarkt(int anzahlRegale, int maxKunden) {
		anzahlWartendeAnKasse = 0;
		warteschlangeKasse = new int[maxKunden];
		anzahlKunden = 0;
		regalBesetzt = new boolean[anzahlRegale];
		anzahlWartendeAnKasse = 0;
		warteschlangeKasse = new int[maxKunden];
	}
	
	public synchronized void supermarktBetreten(int id) throws InterruptedException {
		while (anzahlKunden > maxKunden) {
			
			
			System.out.println("Kunde " + id + " muss warten, da der Supermarkt voll ist.");
			wait();
			
		}
		anzahlKunden++;
		System.out.println("Kunde " + id + " hat den Supermarkt betreten.");
		
		
	}
	
	public synchronized void vorRegalStellen(int id, int regalnummer)
		throws InterruptedException {
		while (regalBesetzt[regalnummer]) {
			
			
			System.out.println("Person " + id + " muss warten, da bereits jemand bei Regal " + regalnummer + " steht.");
			wait();
			
		}
		regalBesetzt[regalnummer] = true;
		
	}
	
	public synchronized void regalVerlassen(int id, int regalnummer) {
		
		regalBesetzt[regalnummer] = false;
		System.out.println("Person " + id + " hat Regal " + regalnummer + " verlassen.");
		notifyAll();
		
	}
	
	public synchronized void anKasseAnstellen(int id) throws InterruptedException {
		
		
		
		
		/*while () {
			
			
		}*/
		warteschlangeKasse[anzahlWartendeAnKasse] = id;
		anzahlWartendeAnKasse++;
		System.out.println("Kunde " + id + " hat sich an der Kasse angestellt.");
		
		
	}
	
	public synchronized void supermarktVerlassen(int id) {
		
		
		anzahlWartendeAnKasse--;
		for (int i = 0; i < anzahlWartendeAnKasse;)
			warteschlangeKasse[i] = warteschlangeKasse[++i];
		warteschlangeKasse[anzahlWartendeAnKasse + 1] = 0;
		anzahlKunden--;
		System.out.println("Kunde " + id + " hat den Supermarkt verlassen.");
		notifyAll();
		
	}
	
	public int getAnzahlRegale() {
		return anzahlRegale;
	}
}
