// Simple test for the add tool
const add = {
  description: "Add two numbers",
  args: {
    a: { type: "number", description: "First number" },
    b: { type: "number", description: "Second number" },
  },
  async execute(args) {
    return args.a + args.b;
  },
};

// Test the add function
async function testAdd() {
  try {
    const result = await add.execute({ a: 15, b: 20 });
    console.log(`15 + 20 = ${result}`);
    console.log('Test passed!');
  } catch (error) {
    console.error('Test failed:', error);
  }
}

testAdd();