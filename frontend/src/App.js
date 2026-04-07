import { useEffect, useState } from 'react';

function App() {
  const [time, setTime] = useState("");

  useEffect(() => {
    fetch("http://YOUR_EC2_IP:3001/api")
      .then(res => res.json())
      .then(data => setTime(data[0].time));
  }, []);

  return (
    <div>
      <h1>Fullstack Practice 🚀</h1>
      <p>{time}</p>
    </div>
  );
}

export default App;
