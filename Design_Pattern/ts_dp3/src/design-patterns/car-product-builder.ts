export class CarProductBuilder {
    public engine!: string;
    public color!: string;
    public sunroof!: boolean;

    private constructor() {}

    static Builder = class {
        private readonly car: CarProductBuilder;

        constructor() {
            this.car = new CarProductBuilder();
        }

        public setEngine(engine: string): this {
            this.car.engine = engine;
            return this;
        }

        public setColor(color: string): this {
            this.car.color = color;
            return this;
        }

        public setSunroof(sunroof: boolean): this {
            this.car.sunroof = sunroof;
            return this;
        }

        public build(): CarProductBuilder {
            return this.car
        }
    }
}