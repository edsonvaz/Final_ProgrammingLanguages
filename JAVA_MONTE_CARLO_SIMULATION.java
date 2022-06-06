import java.util.Random;

public class MyClass {
    
    public static double rands(double min, double max) {
		double range = max - min;
		double div = Integer.MAX_VALUE / range;
		return min + (RANDOM.nextInt() & Integer.MAX_VALUE) / div;
	}

	public static int whoAttacks(int n, int min, int max) {
		return n + (RANDOM.nextInt() & Integer.MAX_VALUE) % (max + 1 - min) + 0;
	}

	public static void printMatrix(double[][] m) {
		System.out.println();
		for(int row = 0; row < 3; row++) {
			for(int column = 0; column < 3; column++) {
				System.out.printf("%.1f  ", m[row][column]);
			}
			System.out.println();
		}
	}
	
	public static void suddenDeath(double[][] m, int n, int attacker, int f1, int f2, byte g1, byte g2) {
	    for (int i = 0; i < n; ++i){
	        
        if(f1 == 0){
            System.out.println("\nGroup " + ((char)Byte.toUnsignedInt(g1)) + " is annihilated!\n");
    		System.out.println("==================================\nGroup " + ((char)Byte.toUnsignedInt(g2)) + " is the winner!\n==================================");
            break;
        }else if(f2 == 0){
            System.out.println("\nGroup " + ((char)Byte.toUnsignedInt(g2)) + " is annihilated!\n");
		    System.out.println("==================================\nGroup " + ((char)Byte.toUnsignedInt(g1)) + " is the winner!\n==================================");
            break;
        }

        attacker = whoAttacks(0,0,1);

        switch(attacker){
            case 0:
                    f2 -= 1;
                    System.out.println("\nGroup " + ((char)Byte.toUnsignedInt(g1)) + " attacked group " + ((char)Byte.toUnsignedInt(g2)) + "!");
		            System.out.println("Number of warriors for each group\nGroup " + ((char)Byte.toUnsignedInt(g1)) + ": " + f1 + "\nGroup " + ((char)Byte.toUnsignedInt(g2)) + ": " + f2);
                break;
            case 1:
                    f1 -= 1;
                    System.out.println("\nGroup " + ((char)Byte.toUnsignedInt(g2)) + " attacked group " + ((char)Byte.toUnsignedInt(g1)) + "!");
		System.out.println("Number of warriors for each group\nGroup " + ((char)Byte.toUnsignedInt(g1)) + ": " + f1 + "\nGroup " + ((char)Byte.toUnsignedInt(g2)) + ": " + f2);
                break;
        }


    }
	}
	
	
	public static void monteCarlo(double[][] m, int n, double rand, int attacker, int f0, int f1, int f2) {
		double x;
	    byte zero = '0', one = '1', two = '2';
	    double[][] newFactions = {{0.0, 1.0}, {1.0, 0.0}};
	    
	    for (int i = 0; i < n; ++i){
        if(f0 == 0){
            System.out.println("\nGroup 0 is annihilated!\n");
            System.out.println("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker,f1,f2,one, two);
            break;
        }else if(f1 == 0){
            System.out.println("\nGroup 1 is annihilated!\n");
            System.out.println("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker,f0,f2, zero,two);
            break;
        }else if(f2 == 0){
            System.out.println("\nGroup 2 is annihilated!\n");
            System.out.println("==================================\nReconfiguring stochastic matrix\n");
            suddenDeath(newFactions,n, attacker, f0,f1, zero, one);
            break;
        }

        attacker = whoAttacks(0,0,2);
        rand = rands(0.0, 1.0);

        switch(attacker){
            case 0:
                x = m[0][1];

                if (rand > 0.0 && rand <= x){
                    f1 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 1!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }else{
                    f2 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 2!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }

                break;
            case 1:
                x = m[1][0];

                if (rand > 0.0 && rand <= x){
                    f0 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 0!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }else{
                    f2 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 2!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }

                break;
            case 2:
                x = m[2][0];

                if (rand > 0.0 && rand <= x){
                    f0 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 0!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }else{
                    f1 -= 1;
                    System.out.println("\nGroup " + attacker + " attacked group 1!");
		            System.out.println("Number of warriors for each group\nGroup 0: " + f0 + "\nGroup 1: " + f1 + "\nGroup 2: " + f2);
                }

                break;
        }

    }
	    
	}

	public final static Random RANDOM = new Random(1);
    
    
    public static void main(String args[]) {
        
    int wa = 5, wb = 5, wc = 5, N = 50;

	double[][] factions = {{0.0, 0.7, 0.3}, {0.4, 0.0, 0.6}, {0.6, 0.4, 0.0}};
	printMatrix(factions);
	
	System.out.println("\nNumber of warriors for each group\nGroup 0: " + wa + "\nGroup 1: " + wb + "\nGroup 2: " + wc);
	System.out.println("==================================");
	
	RANDOM.setSeed(System.currentTimeMillis());
    double aran = rands(0.0, 1.0);
	
	double rand=0;
    int attacker=0;
    
    monteCarlo(factions, N, rand, attacker, wa,wb,wc);
	
    }
}
