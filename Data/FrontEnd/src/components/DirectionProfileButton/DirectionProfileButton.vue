<template>
    <button class="button">
        <svg xmlns="http://www.w3.org/2000/svg" width="20" viewBox="0 0 20 20" height="20" fill="none" class="svg-icon">
            <g stroke-width="1.5" stroke-linecap="round" stroke="#ffffff">
                <circle r="7.5" cy="10" cx="10"></circle>
                <path d="m9.99998 7.5v5"></path>
                <path d="m7.5 9.99998h5"></path>
            </g>
        </svg>
    </button>
</template>
<script>
export default {
    name: "DirectionProfileButton",
};
</script>
<style scoped>
.button {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 6px 12px;
    gap: 4px;
    height: 32px;
    width: 51px;
    border: none;
    background: #243328;
    border-radius: 20px;
    cursor: pointer;
    margin: 0 auto;
    transition: all .3s;
}

.lable {
    line-height: 22px;
    font-size: 17px;
    color: #ffffff;
    font-family: sans-serif;
    letter-spacing: 1px;
}

.button:hover {
    background: #3d4840;
    color: black;
}

.button:hover .svg-icon {
    animation: rotate 1.3s linear infinite;
}

@keyframes rotate {
    0% {
        transform: rotate(0deg);
    }

    25% {
        transform: rotate(10deg);
    }

    50% {
        transform: rotate(0deg);
    }

    75% {
        transform: rotate(-10deg);
    }

    100% {
        transform: rotate(0deg);
    }
}
</style>