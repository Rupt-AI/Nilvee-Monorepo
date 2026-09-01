import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 500 }, // Ramps virtual concurrent users from 0 to 500
    { duration: '1m',  target: 500 }, // Sustains peak stress load for a full minute
    { duration: '10s', target: 0 },   // Cools down the connection grid back to zero
  ],
  thresholds: {
    'http_req_duration': ['p(95)<500'], // Latency constraint boundary
    'http_req_failed': ['rate<0.01'],   // Error drop budget allocation
  },
};

export default function () {
  const targetUrl = 'http://cluster.local';
  const params = {
    headers: {
      'Host': '://yourcompany.com',
      'User-Agent': 'k6-Automated-Performance-Runner',
    },
  };

  const res = http.get(targetUrl, params);

  check(res, {
    'http connection status was 200 ok': (r) => r.status === 200,
    'body payload length is valid': (r) => r.body && r.body.length > 0,
  });

  sleep(1);
}
