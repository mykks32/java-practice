export class CarRegistry {
    private static INSTANCE: CarRegistry;

    private constructor() {}

    public static getInstance(): CarRegistry {
        if (!this.INSTANCE) {
            this.INSTANCE = new CarRegistry();
        }
        return this.INSTANCE;
    }

    public register(carId: string) {
        console.log(`Register Car ${carId}`);
    }
}
