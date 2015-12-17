rng(1);
num_s = 2;
num_u = 2;
num_a = 3;
beta = zeros(num_s, 1);
beta(1) = 1;

p = rand(num_s, num_a, num_s);

pi_u = zeros(num_s, num_u);
pi_u(1, :) = [0.2, 0.8];
pi_u(2, :) = [0.3, 0.7];
q = rand(num_s, num_u);

pi_a = zeros(num_s, num_u, num_a);
pi_a(1, 1, :) = [0.1, 0.2, 0.7];
pi_a(1, 2, :) = [0.4, 0.1, 0.1];
pi_a(2, 1, :) = [0.3, 0.1, 0.6];
pi_a(2, 2, :) = [0.1, 0.5, 0.4];

v = zeros(num_s, 1);
for s = 1:num_s
    temp_sum = 0;
    for u = 1:num_u
        temp_sum = temp_sum + pi_u(s, u)*q(s, u);
    end
    v(s) = temp_sum;
end
disp(v)

temp_pi_u = zeros(num_s, num_s*num_u);
temp_pi_u(1, 1:num_u) = pi_u(1, :);
temp_pi_u(2, num_u+1:end) = pi_u(2, :);

disp(temp_pi_u * reshape(q', num_u*num_s, 1));

new_q = zeros(size(q));
vsa = zeros(num_s, num_a);
for s = 1:num_s
    for u = 1:num_u
        temp_sum = 0;
        for a = 1:num_a
            vsa_sum = 0;
            for sp = 1:num_s
                vsa_sum = vsa_sum + p(s, a, sp) * v(sp);
            end
            vsa(s, a) = vsa_sum;
            temp_sum = temp_sum + pi_a(s, u, a) * vsa_sum;
        end
        new_q(s, u) = temp_sum;
    end
end
disp(new_q);

x = reshape(pi_a, num_s*num_u,num_a);
temp_pi_a = zeros(num_s*num_u, num_s*num_a);
temp_pi_a(:, 1:2) = repmat(x(:, 1), 1, 2);
temp_pi_a(:, 3:4) = repmat(x(:, 2), 1, 2);
temp_pi_a(:, 5:6) = repmat(x(:, 3), 1, 2);
temp_pi_a([1, 3], [2 4 6]) = 0;
temp_pi_a([2, 4], [1 3 5]) = 0;
temp_v = reshape(p, num_s*num_a, num_s) * v;


disp(temp_pi_a*temp_v);






